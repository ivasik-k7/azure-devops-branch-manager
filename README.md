# ADBM: Azure DevOps Branch Manager

ADBM is a command-line utility designed to streamline the management of development branches in a Git repository, particularly for tasks associated with Azure DevOps work items. It allows you to create branches based on work item details and configure essential settings like project name, organization, and personal access tokens (PATs).

## Features

- **Create Branches:** Automatically generate Git branches based on Azure DevOps work item details.
- **Configure Settings:** Set up your project, organization, and PAT.
- **Validate PAT:** Check if the provided PAT is valid and has the necessary permissions.

## Commands

### `adbm help`

Displays usage information and helps you understand how to use the script.

**Usage:**

```bash
adbm help
```

### `adbm configure <variable>=<value>`

Configures essential variables needed for the script to function. The script requires the following variables:

- `project=<project_name>`: The name of your Azure DevOps project.
- `organization=<organization_name>`: The name of your Azure DevOps organization.
- `pat=<personal_access_token>`: Your Azure DevOps Personal Access Token.

**Usage:**

```bash
adbm configure project=your_project_name organization=your_organization_name pat=your_personal_access_token
```

### `adbm branch <branch_code>`

Creates a new Git branch based on the task details retrieved from Azure DevOps. The branch name is constructed using the task ID and its details.

**Usage:**

```bash
adbm branch <task_id>
```

## Configuration

Before running the script, ensure you have the following utilities installed:

- `jq` - A command-line JSON processor.
- `curl` - A tool to transfer data from or to a server.

## How It Works

1. **Check Utilities**: Verifies that the required utilities (`jq` and `curl`) are installed.
2. **Check Configuration**: Validates that necessary environment variables (`PROJECT_NAME`, `ORG_NAME`, `PAT`) are set.
3. **Validate PAT**: Checks the validity of the Personal Access Token.
4. **Fetch Task Details**: Retrieves task information from Azure DevOps using the provided task ID.
5. **Create Branch**: Constructs a branch name based on the task details and creates the branch in the Git repository.

## Troubleshooting

- Ensure you have `jq` and `curl` installed.
- Confirm that environment variables are correctly set in your `.bashrc` or another configuration file.
- Check that your Personal Access Token is valid and has the required permissions.

For any issues or contributions, please refer to the project's issue tracker.
