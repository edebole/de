# AI Data Extraction

AI Data Extraction is an AI-powered tool designed to extract and collect structured data from websites. It includes a configurable logging system via the `Loggable` module, ensuring full traceability of the data extraction process.

## Setup

Clone the repository and run the following command to install dependencies and prepare the environment:

```bash
bin/setup
```

This script will:

    Install required Ruby gems via bundle install

    Create any necessary folders or initial configuration

## Usage
First setup the docker environment using:
```bash
bin/setup
```

To start the scraper, run:
```bash
bin/play
```
This will start the main scraping process and begin logging activity using the Loggable module. If a log file is specified, logs will be written there; otherwise, they will be printed to the console (stdout).

## Running docker commands

You can run commands like yarn, node, bundle, etc., using the bin/run script. This ensures that the correct environment and versions are used for the project.

Example:
```bash
bin/run yarn install
```
This will run yarn install within the project context.
Project structure

    bin/setup – Script to set up the project environment

    bin/play – Entry point to run the scraper

    bin/run – Wrapper to run commands in the docker environment
