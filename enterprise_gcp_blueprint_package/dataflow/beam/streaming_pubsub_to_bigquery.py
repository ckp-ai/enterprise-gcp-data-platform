import argparse, json, logging
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions

class ParseAndValidate(beam.DoFn):
    def process(self, msg):
        try:
            row = json.loads(msg.decode("utf-8"))
            if not row.get("event_id") or not row.get("event_ts"):
                raise ValueError("missing required fields")
            yield row
        except Exception as exc:
            logging.exception("Invalid message")
            yield beam.pvalue.TaggedOutput("deadletter", {"payload": msg.decode("utf-8", "ignore"), "error": str(exc)})

def run(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--input_subscription", required=True)
    parser.add_argument("--output_table", required=True)
    parser.add_argument("--deadletter_table", required=True)
    known, pipeline_args = parser.parse_known_args(argv)
    with beam.Pipeline(options=PipelineOptions(pipeline_args, save_main_session=True, streaming=True)) as p:
        parsed = (p | "Read" >> beam.io.ReadFromPubSub(subscription=known.input_subscription).with_output_types(bytes)
                    | "ParseValidate" >> beam.ParDo(ParseAndValidate()).with_outputs("deadletter", main="valid"))
        parsed.valid | "WriteBQ" >> beam.io.WriteToBigQuery(known.output_table, write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND)
        parsed.deadletter | "WriteDLQ" >> beam.io.WriteToBigQuery(known.deadletter_table, write_disposition=beam.io.BigQueryDisposition.WRITE_APPEND)

if __name__ == "__main__":
    logging.getLogger().setLevel(logging.INFO)
    run()
