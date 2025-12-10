import React, { useState, useEffect } from 'react';
import { haversineDistance, sortBedsByDistance } from './utils/distanceCalculations';
import { filterPlantsByAccsta, parseBedString, upsertItem } from './services/dataService';

// Mock data to simulate real app data
const mockPlants = [
  { recnum: 1001, name: 'English Oak', accsta: 'C', bed: 'PW1 PW2', description: 'Large deciduous tree native to Europe' },
  { recnum: 1002, name: 'Japanese Maple', accsta: 'C', bed: 'L-2', description: 'Small ornamental tree with delicate leaves' },
  { recnum: 1003, name: 'Rhododendron', accsta: 'X', bed: 'PW3', description: 'Evergreen shrub with showy flowers' },
  { recnum: 1004, name: 'Lavender', accsta: 'C', bed: 'PW1 L-2', description: 'Fragrant perennial herb with purple flowers' },
  { recnum: 1005, name: 'Rosemary', accsta: 'D', bed: 'PW2', description: 'Woody perennial herb with needle-like leaves' },
];

const mockBeds = [
  { id: 'PW1', name: 'Plant World 1', latitude: 53.2755, longitude: -3.0425 },
  { id: 'PW2', name: 'Plant World 2', latitude: 53.2762, longitude: -3.0418 },
  { id: 'PW3', name: 'Plant World 3', latitude: 53.2748, longitude: -3.0431 },
  { id: 'L-2', name: 'Lake District', latitude: 53.2742, longitude: -3.0405 },
  { id: 'GH1', name: 'Greenhouse 1', latitude: 53.2758, longitude: -3.0398 },
];

const userLocation = { latitude: 53.275, longitude: -3.041 };

const App: React.FC = () => {
  const [plants, setPlants] = useState<any[]>([]);
  const [beds, setBeds] = useState<any[]>([]);
  const [sortedBeds, setSortedBeds] = useState<any[]>([]);
  const [selectedPlant, setSelectedPlant] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Simulate loading data
    setTimeout(() => {
      // Filter plants by accsta === "C"
      const filteredPlants = filterPlantsByAccsta(mockPlants);
      
      // Parse bed strings for each plant
      const plantsWithBeds = filteredPlants.map(plant => ({
        ...plant,
        bedIds: parseBedString(plant.bed)
      }));
      
      // Sort beds by distance from user location
      const sortedBeds = sortBedsByDistance(
        mockBeds, 
        userLocation.latitude, 
        userLocation.longitude
      );
      
      setPlants(plantsWithBeds);
      setBeds(mockBeds);
      setSortedBeds(sortedBeds);
      setLoading(false);
    }, 1000);
  }, []);

  const handlePlantSelect = (plant: any) => {
    setSelectedPlant(plant);
  };

  const handleCloseDetail = () => {
    setSelectedPlant(null);
  };

  if (loading) {
    return (
      <div style={{ padding: '20px', fontFamily: 'Arial, sans-serif', maxWidth: '800px', margin: '0 auto' }}>
        <h1>Ness Gardens Visitor Guide</h1>
        <p>Loading plant data...</p>
      </div>
    );
  }

  if (selectedPlant) {
    // Find beds for this plant
    const plantBeds = mockBeds.filter(bed => selectedPlant.bedIds.includes(bed.id));
    
    return (
      <div style={{ padding: '20px', fontFamily: 'Arial, sans-serif', maxWidth: '800px', margin: '0 auto' }}>
        <button 
          onClick={handleCloseDetail}
          style={{
            marginBottom: '20px',
            padding: '8px 16px',
            backgroundColor: '#007bff',
            color: 'white',
            border: 'none',
            borderRadius: '4px',
            cursor: 'pointer'
          }}
        >
          ← Back to Plant List
        </button>
        
        <h1>{selectedPlant.name}</h1>
        <p><strong>Description:</strong> {selectedPlant.description}</p>
        
        <h2>Location Information</h2>
        <p>This plant can be found in the following areas:</p>
        <ul>
          {plantBeds.map(bed => {
            const distance = haversineDistance(
              userLocation.latitude, 
              userLocation.longitude, 
              bed.latitude, 
              bed.longitude
            );
            return (
              <li key={bed.id}>
                <strong>{bed.name}</strong> - {distance.toFixed(2)} km away
              </li>
            );
          })}
        </ul>
        
        <h2>Nearby Beds</h2>
        <p>Other beds you might want to visit:</p>
        <ol>
          {sortedBeds.slice(0, 3).map(bed => (
            <li key={bed.id}>
              <strong>{bed.name}</strong> - {bed.distance.toFixed(2)} km away
            </li>
          ))}
        </ol>
      </div>
    );
  }

  return (
    <div style={{ padding: '20px', fontFamily: 'Arial, sans-serif', maxWidth: '800px', margin: '0 auto' }}>
      <header style={{ 
        backgroundColor: '#f8f9fa', 
        padding: '20px', 
        borderRadius: '8px', 
        marginBottom: '20px',
        textAlign: 'center'
      }}>
        <h1>Ness Gardens Visitor Guide</h1>
        <p>Your digital companion for exploring the botanical gardens</p>
      </header>

      <section style={{ marginBottom: '30px' }}>
        <h2>Nearby Beds</h2>
        <p>Based on your current location, these are the nearest garden areas:</p>
        <div style={{ display: 'flex', gap: '15px', flexWrap: 'wrap' }}>
          {sortedBeds.slice(0, 3).map(bed => (
            <div 
              key={bed.id} 
              style={{
                border: '1px solid #dee2e6',
                borderRadius: '8px',
                padding: '15px',
                width: '200px',
                backgroundColor: '#fff'
              }}
            >
              <h3 style={{ margin: '0 0 10px 0' }}>{bed.name}</h3>
              <p style={{ margin: '0 0 10px 0' }}>Distance: {bed.distance.toFixed(2)} km</p>
              <button 
                style={{
                  padding: '6px 12px',
                  backgroundColor: '#28a745',
                  color: 'white',
                  border: 'none',
                  borderRadius: '4px',
                  cursor: 'pointer'
                }}
              >
                Navigate
              </button>
            </div>
          ))}
        </div>
      </section>

      <section>
        <h2>Featured Plants</h2>
        <p>Discover some of our curated plant collection:</p>
        <div style={{ display: 'flex', flexDirection: 'column', gap: '15px' }}>
          {plants.map(plant => (
            <div 
              key={plant.recnum}
              onClick={() => handlePlantSelect(plant)}
              style={{
                border: '1px solid #dee2e6',
                borderRadius: '8px',
                padding: '15px',
                backgroundColor: '#fff',
                cursor: 'pointer',
                transition: 'box-shadow 0.2s'
              }}
              onMouseEnter={(e) => e.currentTarget.style.boxShadow = '0 4px 8px rgba(0,0,0,0.1)'}
              onMouseLeave={(e) => e.currentTarget.style.boxShadow = 'none'}
            >
              <h3 style={{ margin: '0 0 10px 0' }}>{plant.name}</h3>
              <p style={{ margin: '0 0 10px 0' }}>{plant.description}</p>
              <p style={{ margin: '0', fontSize: '14px', color: '#6c757d' }}>
                Located in: {plant.bedIds.join(', ')}
              </p>
            </div>
          ))}
        </div>
      </section>

      <footer style={{ 
        marginTop: '30px', 
        paddingTop: '20px', 
        borderTop: '1px solid #dee2e6',
        textAlign: 'center',
        color: '#6c757d'
      }}>
        <p>Ness Gardens Visitor Guide • Data synchronized with park database</p>
      </footer>
    </div>
  );
};

export default App;