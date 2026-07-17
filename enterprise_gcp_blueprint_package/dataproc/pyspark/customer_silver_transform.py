from pyspark.sql import SparkSession
from pyspark.sql.functions import col, current_timestamp, sha2, concat_ws

spark = SparkSession.builder.appName("customer-silver-transform").getOrCreate()
input_path = "gs://edp-raw/customer/events/"
output_path = "gs://edp-silver/customer/events/"

df = spark.read.parquet(input_path)
validated = (df
    .filter(col("customer_id").isNotNull())
    .withColumn("record_hash", sha2(concat_ws("||", *df.columns), 256))
    .withColumn("processed_ts", current_timestamp()))
validated.write.mode("append").partitionBy("event_date").parquet(output_path)
