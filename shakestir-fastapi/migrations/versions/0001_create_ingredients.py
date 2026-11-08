"""Create ingredients with catalog fields and constraints."""

import sqlalchemy as sa
from alembic import op

revision = "0001"
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "ingredients",
        sa.Column("id", sa.Integer(), primary_key=True),
        sa.Column("name", sa.String()),
        sa.Column("description", sa.Text()),
        sa.Column("image_key", sa.String(), nullable=True),
        sa.Column("normalized_name", sa.String()),
        sa.Column("category", sa.String(), nullable=False, server_default="other"),
        sa.Column(
            "alcohol_status", sa.String(), nullable=False, server_default="unknown"
        ),
        sa.Column("alcohol_by_volume", sa.Numeric(5, 2)),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False),
        sa.CheckConstraint(
            "category IN ('spirit','liqueur','wine','beer','mixer','juice','syrup','fruit','dairy','herb','spice','ice','other')",
            name="ingredients_category",
        ),
        sa.CheckConstraint(
            "alcohol_status IN ('alcoholic','non_alcoholic','unknown')",
            name="ingredients_alcohol_status",
        ),
        sa.CheckConstraint(
            "alcohol_by_volume IS NULL OR (alcohol_by_volume >= 0 AND alcohol_by_volume <= 100)",
            name="ingredients_alcohol_by_volume_range",
        ),
    )
    op.create_index(
        "ix_ingredients_normalized_name", "ingredients", ["normalized_name"]
    )


def downgrade() -> None:
    op.drop_index("ix_ingredients_normalized_name", table_name="ingredients")
    op.drop_table("ingredients")
