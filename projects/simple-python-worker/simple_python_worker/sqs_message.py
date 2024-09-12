from typing import Dict
import json
from pydantic import BaseModel, ValidationError


class SQSMessageBody(BaseModel):
    message: str
    taskToken: str


class SQSMessage(BaseModel):
    MessageId: str
    ReceiptHandle: str
    MD5OfBody: str
    Body: str
    Attributes: Dict[str, str]

    def get_body_as_model(self) -> SQSMessageBody:
        """ Deserialize the Body field into a BodyModel instance. """
        try:
            body_dict = json.loads(self.Body)
            return SQSMessageBody(**body_dict)
        except json.JSONDecodeError as e:
            raise ValueError(f"Failed to deserialize Body: {e}")
        except ValidationError as e:
            raise ValueError(f"Body validation failed: {e}")