"""create contacts table

Revision ID: c2c640e477e8
Revises: 
Create Date: 2023-05-31 00:23:12.137826

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'c2c640e477e8'
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
  op.create_table(
    'contacts',
    sa.Column('id', sa.Integer, primary_key=True),
    sa.Column('first_name', sa.String(50), nullable=False),
    sa.Column('last_name', sa.String(50), nullable=False),
    sa.Column('number', sa.String(15), nullable=False),
    sa.Column('notes', sa.Text),
  )


def downgrade() -> None:
  op.drop_table('contacts')
