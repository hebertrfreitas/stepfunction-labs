from typing import Dict

from pydantic import BaseModel


class SQSMessage(BaseModel):
    MessageId: str
    ReceiptHandle: str
    MD5OfBody: str
    Body: str
    Attributes: Dict[str, str]
