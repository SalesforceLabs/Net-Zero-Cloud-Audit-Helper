@isTest
private with sharing class FootprintInfoTest {
    @isTest
    static void scope3FootprintInfos() {
        Set<String> energyUses = new Set<String>{'AirTravelEnrgyUse', 'FrgtHaulingEnrgyUse', 'GroundTravelEnrgyUse', 'HotelStayEnrgyUse', 'RentalCarEnrgyUse', 'GeneratedWaste'};
        Footprint footprint = FootprintInfo.footprints.get('Scope3CrbnFtprnt');

        for (String energyUse : energyUses) {
            Assert.isNotNull(footprint.items.get(energyUse));
        }
    }

    @isTest
    static void stationaryAssetWaterFootprintInfos() {
        Set<String> energyUses = new Set<String>{'StnryAssetWaterActvty'};
        Footprint footprint = FootprintInfo.footprints.get('StnryAssetWaterFtprnt');

        for (String energyUse : energyUses) {
            Assert.isNotNull(footprint.items.get(energyUse));
        }
    }

    @isTest
    static void stationaryAssetCarbonFootprintInfos() {
        Set<String> energyUses = new Set<String>{'StnryAssetEnrgyUse'};
        Footprint footprint = FootprintInfo.footprints.get('StnryAssetCrbnFtprnt');

        for (String energyUse : energyUses) {
            Assert.isNotNull(footprint.items.get(energyUse));
        }
    }

    @isTest
    static void vehicleAssetFootprintInfos() {
        Set<String> energyUses = new Set<String>{'VehicleAssetEnrgyUse'};
        Footprint footprint = FootprintInfo.footprints.get('VehicleAssetCrbnFtprnt');

        for (String energyUse : energyUses) {
            Assert.isNotNull(footprint.items.get(energyUse));
        }
    }

    @isTest
    static void wasteFootprintInfos() {
        Set<String> energyUses = new Set<String>{'GeneratedWaste'};
        Footprint footprint = FootprintInfo.footprints.get('WasteFootprint');

        for (String energyUse : energyUses) {
            Assert.isNotNull(footprint.items.get(energyUse));
        }
    }
}