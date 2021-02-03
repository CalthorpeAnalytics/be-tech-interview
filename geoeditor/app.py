from flask import Flask
from geoeditor import api
from geoeditor import auth
from geoeditor.extensions import apispec
from geoeditor.extensions import db
from geoeditor.extensions import jwt
from geoeditor.extensions import migrate


def create_app(testing: bool = False) -> Flask:
    """Application factory, used to create application"""
    app = Flask("geoeditor")
    app.config.from_object("geoeditor.config")

    if testing is True:
        app.config["TESTING"] = True

    configure_extensions(app)
    configure_apispec(app)
    register_blueprints(app)

    return app


def configure_extensions(app: Flask) -> None:
    """configure flask extensions"""
    db.init_app(app)
    jwt.init_app(app)
    migrate.init_app(app, db)


def configure_apispec(app: Flask) -> None:
    """Configure APISpec for swagger support"""
    apispec.init_app(app, security=[{"jwt": []}])

    if not apispec.spec:
        raise Exception("Failed to initialize apispec")

    apispec.spec.components.security_scheme(
        "jwt", {"type": "http", "scheme": "bearer", "bearerFormat": "JWT"}
    )
    apispec.spec.components.schema(
        "PaginatedResult",
        {
            "properties": {
                "total": {"type": "integer"},
                "pages": {"type": "integer"},
                "next": {"type": "string"},
                "prev": {"type": "string"},
            }
        },
    )


def register_blueprints(app: Flask) -> None:
    """register all blueprints for application"""
    app.register_blueprint(auth.views.blueprint)
    app.register_blueprint(api.views.blueprint)
