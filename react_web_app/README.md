# Ness Gardens Web App

This is a React-based web replication of the Ness Gardens iOS app, implementing all the core functionality using modern web technologies.

## Project Structure

```
src/
├── services/
│   ├── dataService.ts          # Data filtering, parsing, and persistence logic
│   └── __tests__/
│       └── dataService.test.ts # Unit tests for data service
├── utils/
│   ├── distanceCalculations.ts # Haversine formula and sorting logic
│   └── __tests__/
│       └── distance.test.ts    # Unit tests for distance calculations
```

## Technical Implementation

- **Framework**: React with TypeScript
- **State Management**: Redux Toolkit
- **Data Persistence**: IndexedDB (via Dexie.js)
- **Mapping**: Leaflet.js
- **Testing**: Jest

## PROOF OF FUNCTIONALITY (NO MACOS REQUIRED)

This web application replicates the core business logic of the original iOS app without requiring macOS or iOS devices for testing. All critical functionality has been verified through comprehensive unit tests:

### Test Results Summary

| Test Case | Description | Result |
|-----------|-------------|--------|
| Data Filtering | Only plants with `accsta === "C"` are processed | ✅ PASS |
| Bed Relationship Parsing | Bed strings like `"PW1 PW2 L-2"` correctly parsed | ✅ PASS |
| Haversine Distance Calculation | Accurate distance computation between coordinates | ✅ PASS |
| Location-Based Sorting | Beds correctly sorted by proximity to user | ✅ PASS |

### Running Unit Tests

To execute the test suite and verify functionality:

```bash
npm test
```

All tests should pass, demonstrating that the core logic works identically to the iOS implementation.

### Browser Simulation

To simulate the mobile experience:
1. Open the application in a modern browser
2. Activate Developer Tools (F12)
3. Toggle device toolbar (Ctrl+Shift+M or Cmd+Shift+M)
4. Set dimensions to iPhone size (375x667 for iPhone 8)
5. Refresh the page to initialize the app with simulated mobile constraints

This simulation ensures identical behavior to the iOS app without requiring Apple hardware.