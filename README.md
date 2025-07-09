# fixd-backend

## Prerequisites

- **Ruby**: 3.2.8
- **Rails**: 8.0.2
- **Node.js** with npm and yarn (optional, but recommended for future JavaScript enhancements)

## Getting Started

### Installation

1. Clone the repository:
```bash
git clone https://github.com/etmihailo/fixd-backend
cd fixd-backend
```

2. Install dependencies:
```bash
bundle install
```

### Running the Application

1. Start the development server:
```bash
bin/dev
```

2. Access the application:
   - **Web UI**: http://localhost:3000
   - **GraphQL Interactive Interface**: http://localhost:3000/graphiql

## API Usage

### Sample GraphQL Query

```graphql
query {
  githubEvents(username: "peppy", page: 2, perPage: 10) {
    events {
      type
      repo
      time
    }
    currentPage
    totalPages
    totalCount
    hasNextPage
    hasPreviousPage
  }
}
```

This query will return the second page of events if there are more than 10 items. If there are fewer than 10 items, the first page will be returned.

## Running Tests

### Full Test Suite
```bash
rspec
```

### Specific Test File
```bash
rspec spec/requests/github_events_spec.rb
```

## Known Issues & Potential Improvements

### Security & Validation

- **No Backend Validations**: Due to the lack of a model/record structure, there are no backend validations implemented
- **Missing Strong Parameters**: No strong params are used, which could be a security concern
- **URL Hacking**: Direct access to endpoints like `http://localhost:3000/github_events/peppy?page=1` is possible without authentication or token verification

### Performance & Scalability

- **No Caching**: Repeated requests for the same user could hit API rate limits as there's no caching mechanism in place for the service
- **Pagination Strategy**: Currently using Pagy for pagination, which pulls all records through the service. While GitHub's API supports pagination and limits results to the first 30 pages, implementing API-level pagination could improve performance for larger datasets

### Architecture

- **GraphQL Layer**: Due to time constraints, the GraphQL gem was used directly. For more complex applications, maybe using a separate GraphQL service layer is reasonable to avoid gem constraints
- **Test Coverage**: Common edge cases are covered, but more complex scenarios may require additional test coverage
- **Error Handling**: General error handling is implemented, but more sophisticated error handling could be added
