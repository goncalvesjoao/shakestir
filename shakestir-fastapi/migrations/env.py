from alembic import context

from shakestir.db import create_database_engine
from shakestir.models import Ingredient  # noqa: F401
from shakestir.models.base import Base
from shakestir.settings import settings

target_metadata = Base.metadata

if context.is_offline_mode():
    context.configure(
        url=settings.normalized_database_url(),
        target_metadata=target_metadata,
        literal_binds=True,
    )
    with context.begin_transaction():
        context.run_migrations()
else:
    engine = create_database_engine()
    with engine.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            render_as_batch=connection.dialect.name == "sqlite",
            compare_type=True,
        )
        with context.begin_transaction():
            context.run_migrations()
    engine.dispose()
