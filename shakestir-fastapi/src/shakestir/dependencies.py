from typing import Annotated

from fastapi import Depends
from sqlalchemy.orm import Session

from shakestir.db import get_session

GetSession = Annotated[Session, Depends(get_session)]
