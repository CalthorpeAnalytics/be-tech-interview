import click
from flask.cli import with_appcontext


@click.group()
def cli() -> None:
    """Main entry point"""


@cli.command("init")
@with_appcontext
def init() -> None:
    """Create a new admin user"""
    from geoeditor.extensions import db
    from geoeditor.models import User

    click.echo("create user")
    user = User(username="admin", email="admin@mail.com", password="admin", active=True)
    db.session.add(user)
    db.session.commit()
    click.echo("created user admin")


if __name__ == "__main__":
    cli()
