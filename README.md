# PotionJobs

A Model Context Protocol (MCP) server that provides tools for searching Elixir developer job listings from Elixir Forum.

## Overview

PotionJobs is an Elixir application that exposes two MCP tools:
- **ElixirForumLastJobs**: Fetches the latest Elixir job postings
- **ElixirForumJobDetails**: Retrieves detailed information about a specific job offer

This allows AI assistants (like Claude, ChatGPT, etc.) to access current Elixir job opportunities through the MCP protocol.

## Installation

### Prerequisites
- Elixir 1.19+
- Erlang/OTP 26+

### Setup

1. Clone the repository
```bash
git clone <repository-url>
cd potion_jobs
```

2. Install dependencies
```bash
mix deps.get
```

3. Run the server
```bash
mix run --no-halt
```

The server will start on `http://localhost:4000` with the MCP endpoint at `/mcp`.

## Usage

### Connecting an MCP Client

Via HTTP transport (if supported by your client):
```
http://localhost:4000/mcp
```

### Available Tools

#### 1. elixir_forum_last_jobs

Fetches the latest Elixir job listings from Elixir Forum.



#### 2. elixir_forum_job_details

Retrieves full details of a specific job posting.


## Development

### Running Tests

```bash
mix test
```

### Code Quality

Run Credo for code quality checks:
```bash
mix credo
```


