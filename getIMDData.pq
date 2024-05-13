(postcode as text, imd_domain as text, imd_metric as text) => 

    let 

        // Create postcode query
        postcode_query = 
            "SELECT * WHERE {
                ?postcode <http://publishmydata.com/def/ontology/foi/code> '" & Text.Remove(postcode, " ") & "' .
                ?postcode <http://statistics.data.gov.uk/def/spatialrelations/within#superoutputarealowerlayer> ?lsoa
            } LIMIT 1",

        // Get postcode data
        postcode_data = Json.Document(Web.Contents("https://statistics.data.gov.uk", [RelativePath="sparql.json", Query=[query=postcode_query], Headers=[Accept="*/*"]])),
        
        // Extract LSOA identifier
        lsoa_data  = postcode_data[results][bindings]{0}[lsoa],
        lsoa_code = Text.AfterDelimiter(lsoa_data[value], "/", {0, RelativePosition.FromEnd}),


        // Set required IMD type
        req_imd_domain = 
            if Text.Lower(imd_domain) = "imd" then "<http://opendatacommunities.org/def/concept/general-concepts/imd/combineddeprivation>" else
            if Text.Lower(imd_domain) = "income" then "<http://opendatacommunities.org/def/concept/general-concepts/imd/incomedeprivation>" else
            if Text.Lower(imd_domain) = "employment" then "<http://opendatacommunities.org/def/concept/general-concepts/imd/employmentdeprivation>" else
            if Text.Lower(imd_domain) = "education" then "<http://opendatacommunities.org/def/concept/general-concepts/imd/educskilltraindepriv>" else
            if Text.Lower(imd_domain) = "health" then "<http://opendatacommunities.org/def/concept/general-concepts/imd/healthdeprivdisability>" else
            if Text.Lower(imd_domain) = "crime" then "<http://opendatacommunities.org/def/concept/general-concepts/imd/crime>" else
            if Text.Lower(imd_domain) = "housing" then "<http://opendatacommunities.org/def/concept/general-concepts/imd/barrierstohousservices>" else
            if Text.Lower(imd_domain) = "living" then "<http://opendatacommunities.org/def/concept/general-concepts/imd/livingenvdepriv>" else 
            if Text.Lower(imd_domain) = "idaci" then "<http://opendatacommunities.org/def/concept/general-concepts/imd/idaci>" else 
            if Text.Lower(imd_domain) = "idaopi" then "<http://opendatacommunities.org/def/concept/general-concepts/imd/idaopi>" else 
            "ERROR",


        // Set required IMD metric
        req_imd_metric = 
            if Text.Lower(imd_metric) = "score" then "<http://opendatacommunities.org/def/ontology/communities/societal_wellbeing/imd/scoreObs>" else 
            if Text.Lower(imd_metric) = "rank" then "<http://opendatacommunities.org/def/ontology/communities/societal_wellbeing/imd/rankObs>" else 
            if Text.Lower(imd_metric) = "decile" then "<http://opendatacommunities.org/def/ontology/communities/societal_wellbeing/imd/decObs>" else 
            "ERROR",


        // Create IMD query
        imd_query = 
            "SELECT * WHERE {
                ?obs <http://opendatacommunities.org/def/ontology/geography/refArea> <http://opendatacommunities.org/id/geography/administration/lsoa/" & lsoa_code & "> .
                ?obs <http://opendatacommunities.org/def/ontology/communities/societal_wellbeing/imd/indices> " & req_imd_domain & " .
                ?obs <http://opendatacommunities.org/def/ontology/time/refPeriod> <http://reference.data.gov.uk/id/year/2019> .
                ?obs " & req_imd_metric & " ?score
            } LIMIT 1",

        // Get metric data
        imd_data = Json.Document(Web.Contents("http://opendatacommunities.org", [RelativePath="sparql.json", Query=[query=imd_query], Headers=[Accept="*/*"]])),
        result = try imd_data[results][bindings]{0}[score][value] otherwise null

    in
        result
