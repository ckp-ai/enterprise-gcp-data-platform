"""Reference RAG pattern. Configure project, location, model and vector index before production use."""
from google.cloud import aiplatform

PROJECT_ID = "gcp-edp-ai-prod-001"
LOCATION = "us-central1"

def retrieve_context(query: str) -> list[str]:
    # Replace with Vector Search nearest-neighbor query using enterprise metadata filters.
    return ["Certified policy context retrieved from governed data product."]

def build_prompt(query: str, contexts: list[str]) -> str:
    joined = "
".join(f"SOURCE {i+1}: {c}" for i, c in enumerate(contexts))
    return f"""You are an enterprise assistant. Answer only from provided sources.
If sources are insufficient, say so. Include citations.

{joined}

QUESTION: {query}
ANSWER:"""

def answer(query: str) -> str:
    aiplatform.init(project=PROJECT_ID, location=LOCATION)
    contexts = retrieve_context(query)
    prompt = build_prompt(query, contexts)
    # Call Gemini through approved enterprise gateway / Vertex AI SDK in production.
    return prompt

if __name__ == "__main__":
    print(answer("What is the customer data retention policy?"))
