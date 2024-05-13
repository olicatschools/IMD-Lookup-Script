# IMD-Lookup-Script
This is a PowerQuery / M Language function for looking up 2019 IMD information from postcodes. 

###### Data Sharing Note:
###### The script sends individual postcodes to the ONS Geography Linked Data API and then passes the corresponding LSOA identity to Department for Levelling Up, Housing & Communities Open Data Communities API.

## Prerequisities
You will need a copy of the script code from **getIMDData.pq** found on this page and a table in PowerQuery that has postcodes stored individually in a column. Postcodes can contain spaces.

## How to use it

### Adding the script to your PBI / Excel file
1. In PowerBI or Excel open the PowerQuery editor (for PowerBI select **Transform Data** from the **Home** menu)
2. On the left side under the **Queries** heading right click a blank space and choose **New Query** followed by **Blank Query**
3. Right click on the new query, select **Rename** and it give it a name (I use **getIMDData**)
4. Ensure the query is highlighted in the left hand panel and select **Advanced Editor** from the **Home** menu (next to **Refresh Preview**)
5. Copy the script code from **getIMDData.pq** and past it into the **Advanced Editor** window

#### Using the script to get IMD data
To use the script go to the table containing your postcode data, select the **Invoke Custom Function** option from the **Add Column** menu. In the box that appears give your new column a name and under **Function Query** choose the query you pasted the script code into. At this point three more boxes will appear, in **postcode** choose the name of the column that contains your postcode data.

Under **imd_domain** you will need to enter a short code representing the IMD domain you want data for. The available domains are:

| Domain Short Code  | Domain Description                                       |
| ------------------ | -------------------------------------------------------- |
| IMD                | Index of Multiple Deprivation (IMD)                      |
| INCOME             | Income Deprivation Domain                                |
| EMPLOYMENT         | Employment Deprivation Domain                            |
| EDUCATION          | Education, Skils and Training Domain                     |
| HEALTH             | Health Deprivation and Disability Domain                 |
| CRIME              | Crime Domain                                             |
| HOUSING            | Barriers to Houseing and Services Domain                 |
| LIVING             | Living Environment Deprivation Domain                    |
| IDACI              | Income Deprivation Affecting Children Index (IDACI)      |
| IDAOPI             | Income Deprivation Affecting Older People Index (IDAOPI) |

Under **imd_metric** you will need to select the metric you want data for. The available metrics are:

| Metric Short Code | Metric Description                                    |
| ----------------- | ----------------------------------------------------- |
| SCORE             | The postcode's score for the chosen domain            |
| RANK              | The postcode's ranking within the chosen domain       |
| DECILE            | Which decile the postcode is in for the chosen domain |

## More Information
Information about what each domain and metric measures can be found here:

**[English indices of deprivation 2019](https://www.gov.uk/government/statistics/english-indices-of-deprivation-2019)**

**[English indices of deprivation 2019: technical report](https://www.gov.uk/government/publications/english-indices-of-deprivation-2019-technical-report)**
