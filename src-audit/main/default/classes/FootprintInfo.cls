public with sharing class FootprintInfo {
    public static Map<String, Footprint> footprints = new Map<String, Footprint>();

    static {
        Map<String, Footprint.Item> scope3CarbonFootprintEnergyUses = new Map<String, Footprint.Item>();
        scope3CarbonFootprintEnergyUses.put('AirTravelEnrgyUse', new Footprint.Item('Air Travel Energy Use', 'Scope3CrbnFtprntId'));
        scope3CarbonFootprintEnergyUses.put('FrgtHaulingEnrgyUse', new Footprint.Item('Freight Hauling Energy Use', 'Scope3CrbnFtprntId'));
        scope3CarbonFootprintEnergyUses.put('GroundTravelEnrgyUse', new Footprint.Item('Ground Travel Energy Use', 'Scope3CrbnFtprntId'));
        scope3CarbonFootprintEnergyUses.put('HotelStayEnrgyUse', new Footprint.Item('Hotel Stay Energy Use', 'Scope3CrbnFtprntId'));
        scope3CarbonFootprintEnergyUses.put('RentalCarEnrgyUse', new Footprint.Item('Rental Car Energy Use', 'Scope3CrbnFtprntId'));
        scope3CarbonFootprintEnergyUses.put('GeneratedWaste', new Footprint.Item('Generated Waste', 'Scope3CrbnFtprntId'));

        Map<String, Footprint.Item> stationaryAssetWaterActivities = new Map<String, Footprint.Item>();
        stationaryAssetWaterActivities.put('StnryAssetWaterActvty', new Footprint.Item('Stationary Asset Water Activity', 'StnryAssetWaterFtprntId'));

        Map<String, Footprint.Item> stationaryAssetEnergyUses = new Map<String, Footprint.Item>();
        stationaryAssetEnergyUses.put('StnryAssetEnrgyUse', new Footprint.Item('Stationary Asset Energy Use', 'StnryAssetCrbnFtprntId'));

        Map<String, Footprint.Item> vehicleAssetEnergyUses = new Map<String, Footprint.Item>();
        vehicleAssetEnergyUses.put('VehicleAssetEnrgyUse', new Footprint.Item('Vehicle Asset Energy Use', 'VehicleAssetCrbnFtprntId'));

        Map<String, Footprint.Item> generatedWastes = new Map<String, Footprint.Item>();
        generatedWastes.put('GeneratedWaste', new Footprint.Item('Generated Waste', 'WasteFootprintId'));

        footprints.put('Scope3CrbnFtprnt', new Footprint('Scope 3 Carbon Footprint', scope3CarbonFootprintEnergyUses));
        footprints.put('StnryAssetWaterFtprnt', new Footprint('Stationary Asset Water Footprint', stationaryAssetWaterActivities));
        footprints.put('StnryAssetCrbnFtprnt', new Footprint('Stationary Asset Carbon Footprint', stationaryAssetEnergyUses));
        footprints.put('VehicleAssetCrbnFtprnt', new Footprint('Vehicle Asset Carbon Footprint', vehicleAssetEnergyUses));
        footprints.put('WasteFootprint', new Footprint('Waste Carbon Footprint', generatedWastes));
    }
}