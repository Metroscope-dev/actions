# Notion action.

## Description

Provide a simple python script to update documentation on Notion.so.

## Environment variables

- `SERVICE_NAME`: Name of the service.
- `ARTEFACT_NAME`: Name of the artefact produced.
- `LATEST_TAG`: Latest tag of the service.
- `URL_TEMPLATE`: JFrog url template containing SERVICE_NAME, LATEST_TAG and ARTEFACT_NAME to be replaced with env variable.
- `NOTION_TOKEN`: Obtain the token_v2 value by inspecting your browser cookies on a logged-in (non-guest) session on Notion.so.
- `NOTION_DOCUMENTATION_PAGE`: Notion url page to be updated.
