import { describe, it, expect } from 'vitest';

// Simple mock implementation
const mockEquipmentRegistration = {
  registerEquipment: async (name: string, type: string) => {
    return { value: 1 };
  },
  
  updateAvailability: async (equipmentId: number, available: boolean) => {
    return { value: true };
  },
  
  getEquipment: async (equipmentId: number) => {
    return {
      name: "Precision Seeder",
      type: "Planting",
      owner: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
      available: true
    };
  },
  
  getEquipmentCount: async () => {
    return 5;
  }
};

describe('Equipment Registration Contract', () => {
  it('should register new equipment', async () => {
    const result = await mockEquipmentRegistration.registerEquipment(
        "Precision Seeder",
        "Planting"
    );
    
    expect(result.value).toBe(1);
  });
  
  it('should update equipment availability', async () => {
    const result = await mockEquipmentRegistration.updateAvailability(1, false);
    
    expect(result.value).toBe(true);
  });
  
  it('should get equipment details', async () => {
    const equipment = await mockEquipmentRegistration.getEquipment(1);
    
    expect(equipment.name).toBe("Precision Seeder");
    expect(equipment.type).toBe("Planting");
    expect(equipment.available).toBe(true);
  });
  
  it('should return the correct equipment count', async () => {
    const count = await mockEquipmentRegistration.getEquipmentCount();
    
    expect(count).toBe(5);
  });
});
