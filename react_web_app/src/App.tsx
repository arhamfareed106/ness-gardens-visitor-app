import React, { useState, useEffect } from 'react';
import { haversineDistance, sortBedsByDistance } from './utils/distanceCalculations';
import { filterPlantsByAccsta, parseBedString } from './services/dataService';

const App: React.FC = () => {
  const [testResults, setTestResults] = useState<string[]>([]);
  
  useEffect(() => {
    // Run our core business logic functions to demonstrate they work in a React component
    const results: string[] = [];
    
    // Test data filtering
    const mockPlants = [
      { recnum: 1, name: 'Plant A', accsta: 'C' },
      { recnum: 2, name: 'Plant B', accsta: 'X' },
      { recnum: 3, name: 'Plant C', accsta: 'C' },
      { recnum: 4, name: 'Plant D', accsta: 'D' }
    ];
    
    const filteredPlants = filterPlantsByAccsta(mockPlants);
    results.push(`Filtered plants (accsta === "C"): ${filteredPlants.length}`);
    
    // Test bed string parsing
    const bedString = 'PW1 PW2 L-2';
    const parsedBeds = parseBedString(bedString);
    results.push(`Parsed bed string "${bedString}": [${parsedBeds.join(', ')}]`);
    
    // Test distance calculation
    const distance = haversineDistance(53.275, -3.041, 53.408, -2.991);
    results.push(`Distance calculation: ${distance.toFixed(2)} km`);
    
    // Test bed sorting
    const beds = [
      { id: '1', name: 'Bed A', latitude: 53.276, longitude: -3.042 },
      { id: '2', name: 'Bed B', latitude: 53.408, longitude: -2.991 },
      { id: '3', name: 'Bed C', latitude: 53.275, longitude: -3.041 }
    ];
    
    const sortedBeds = sortBedsByDistance(beds, 53.275, -3.041);
    results.push(`Sorted beds by distance: ${sortedBeds.map(bed => bed.name).join(', ')}`);
    
    setTestResults(results);
  }, []);
  
  return (
    <div style={{ padding: '20px', fontFamily: 'Arial, sans-serif' }}>
      <h1>Ness Gardens Web App</h1>
      <p>This React application demonstrates the core business logic implemented for the Ness Gardens project.</p>
      
      <h2>Core Business Logic Tests</h2>
      <ul>
        {testResults.map((result, index) => (
          <li key={index}>{result}</li>
        ))}
      </ul>
      
      <h2>Proof of Functionality</h2>
      <p>All core business logic has been validated through comprehensive unit tests:</p>
      <ul>
        <li>Data filtering (plants with accsta === "C")</li>
        <li>Bed relationship parsing ("PW1 PW2 L-2" → ["PW1", "PW2", "L-2"])</li>
        <li>Haversine distance calculation (geographic distance)</li>
        <li>Location-based sorting (beds sorted by proximity)</li>
      </ul>
      
      <p>To run the full test suite, execute <code>npm test</code> in the terminal.</p>
    </div>
  );
};

export default App;