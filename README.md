# Net Zero Cloud Audit Helper

## Trial Org Setup

1. Set up your environment. Follow the steps in the [Quick Start: Lightning Web Components](https://trailhead.salesforce.com/content/learn/projects/quick-start-lightning-web-components/) Trailhead project. The steps include:

    - Enable Dev Hub in your Trailhead Playground
    - Install Salesforce CLI
    - Install Visual Studio Code
    - Install the Visual Studio Code Salesforce extensions, including the Lightning Web Components extension

1. Clone this repository:

    ```sh
    git clone https://github.com/trailheadapps/net-zero-cloud-audit-helper.git
    cd net-zero-cloud-audit-helper
    ```

1. Connect to your Net Hub zero org trial with the command below:

    ```sh
    sfdx force:auth:web:login -s -a net-zero-cloud-audit-helper
    ```

1. Push the apps to your scratch org:

    ```sh
    sfdx force:source:deploy -p src-audit
    ```

1. Assign the required permission sets to the default user:

    ```sh
    sfdx force:user:permset:assign -n NetZeroManager,NetZeroAuditor,Net_Zero_Cloud_Audit_Admin,Net_Zero_Cloud_Audit_Auditor
    ```

1. Open the org:

    ```sh
    sfdx force:org:open
    ```

1. Go to **Setup → Security → File Upload and Download Security**, find the **.pdf** label, click the **Edit** button, and set the picklist value to **Execute In Browser.**

    This sets the default behavior for opening PDF files. If you don't change this, PDF files are downloaded instead of being displayed in the browser.

1. For each energy use objects:
    - AirTravelEnrgyUse
    - FrgtHaulingEnrgyUse
    - GroundTravelEnrgyUse
    - HotelStayEnrgyUse
    - RentalCarEnrgyUse
    - GeneratedWaste
    - StnryAssetWaterActvty
    - StnryAssetEnrgyUse
    - VehicleAssetEnrgyUse

   Repeat the following instructions:
    - Add the “Audit” button to the object layout
    - Add the “Audit Error” and “Audit Approval Status” fields to the object layout
    - Activate Chatter feed for the object
