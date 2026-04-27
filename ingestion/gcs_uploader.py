from google.cloud import storage
from datetime import datetime
import json, os
from dotenv import load_dotenv
load_dotenv()

def upload_json_to_gcs(data: dict, folder: str, filename: str):
    """Upload un dict JSON dans GCS."""
    client = storage.Client()
    bucket = client.bucket(os.getenv("GCS_BUCKET"))
    
    # Partitionnement par date
    date_str = datetime.utcnow().strftime("%Y/%m/%d")
    blob_path = f"{folder}/{date_str}/{filename}.json"
    
    blob = bucket.blob(blob_path)
    blob.upload_from_string(
        json.dumps(data, ensure_ascii=False),
        content_type="application/json"
    )
    print(f"Uploaded → gs://{os.getenv('GCS_BUCKET')}/{blob_path}")
    return blob_path