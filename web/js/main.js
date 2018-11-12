
/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function combineAllSource1Data(source) {

    var combineAllSource1DataCheckbox = document.getElementById("combineAllSource1DataCheckbox").checked;

    if (combineAllSource1DataCheckbox === true) {
        $('#selectListSource1').multipleSelect("checkAll");
    } else
    {
        $('#selectListSource1').multipleSelect("uncheckAll");
    }
}

function checkAllAttributes(source) {

    checkboxes = document.getElementsByName('selectedAttributesCheckbox');
    categoryCheckboxes = document.getElementsByName('selectedCategoriesCheckbox');
    var flagCheckAllAttributes = document.getElementById("labelAllAttributesCheckbox").checked;

    if (flagCheckAllAttributes === true) {

        for (var i = 0; i < categoryCheckboxes.length; i++) {
            categoryCheckboxes[i].checked = true;

        }
        for (var i = 0; i < checkboxes.length; i++) {

            checkboxes[i].checked = source.checked;

        }
    } else
    {
        for (var i = 0; i < categoryCheckboxes.length; i++) {
            categoryCheckboxes[i].checked = source.checked;

        }

        for (var i = 0; i < checkboxes.length; i++) {

            checkboxes[i].checked = source.checked;
        }
    }
    countSelectedAttributes();
}
function countSelectedAttributes(source) {
    checkboxes = document.getElementsByName('selectedAttributesCheckbox');
    var flagCheckAllAttributes = document.getElementById("labelAllAttributesCheckbox").checked;
    var count = 0;
    for (var i = 0; i < checkboxes.length; i++) {

        if (checkboxes[i].checked === true)
        {
            count++;
        }

    }

    document.getElementById('numberSelectedAttributesText').value = count + " selected attribute(s).";
}

function checkAttributesByCategory(listAttributesString, category) {

    checkboxes = document.getElementsByName('selectedAttributesCheckbox');
    var flagCheckByCategory = document.getElementById(category).checked;
    var listAttributesArray = listAttributesString.split(",");

    if (flagCheckByCategory === true) {
        for (var i = 0; i < checkboxes.length; i++) {
            var attributeName = checkboxes[i].value;
            if ((listAttributesArray.indexOf(attributeName) > -1))
            {
                checkboxes[i].checked = true;
            }
        }
    } else
    {
        for (var i = 0; i < checkboxes.length; i++) {
            var attributeName = checkboxes[i].value;
            if ((listAttributesArray.indexOf(attributeName) > -1))
            {
                checkboxes[i].checked = false;
            }
        }
    }


    countSelectedAttributes();
}


function checkAllAttributesInstanceProjectionMap(source) {

    checkboxes = document.getElementsByName('selectedAttributesCheckbox');
    clusterboxes = document.getElementsByName('selectedClusterCheckbox');
    var flagCheckAllAttributes = document.getElementById("labelAllAttributesCheckbox").checked;


    for (var i = 0; i < clusterboxes.length; i++) {
        clusterboxes[i].checked = source.checked;

    }

    for (var i = 0; i < checkboxes.length; i++) {

        checkboxes[i].checked = source.checked;
    }
    countSelectedAttributesInstanceProjectionMap();
}

function countSelectedAttributesInstanceProjectionMap(source) {
    checkboxes = document.getElementsByName('selectedAttributesCheckbox');
    var flagCheckAllAttributes = document.getElementById("labelAllAttributesCheckbox").checked;
    var count = 0;
    for (var i = 0; i < checkboxes.length; i++) {

        if (checkboxes[i].checked === true)
        {
            count++;
        }

    }
    if (flagCheckAllAttributes === true)
    {
        count--;
    }
    document.getElementById('numberSelectedAttributesText').value = count + " selected attribute(s).";
}



function checkAttributesByClusterInstanceProjectionMap(listAttributesString, cluster) {
    checkboxes = document.getElementsByName('selectedAttributesCheckbox');
    var flagCheckByCluster = document.getElementById(cluster).checked;
    var listAttributesArray = listAttributesString.split(",");

    if (flagCheckByCluster === true) {
        for (var i = 0; i < checkboxes.length; i++) {
            var attributeName = checkboxes[i].value;
            if ((listAttributesArray.indexOf(attributeName) > -1))
            {
                checkboxes[i].checked = true;
            }
        }
    } else
    {
        for (var i = 0; i < checkboxes.length; i++) {
            var attributeName = checkboxes[i].value;
            if ((listAttributesArray.indexOf(attributeName) > -1))
            {
                checkboxes[i].checked = false;
            }
        }
    }


    countSelectedAttributesInstanceProjectionMap();
}


function blockProjectionVisualization()
{
    var blockProjection = document.getElementById("blockProjectionVisualizationCheckBox").checked;
    if (blockProjection === true)
    {
        document.getElementById('projectionTable').style = "position:fixed;margin:0 auto; margin:auto; margin-left: 2.7%; z-index: 100; text-align: center; background-color: white;";
        document.getElementById('timeMatricesTable').style = "text-align: center;margin:0 auto; margin:auto;margin-top: 595px;";
    } else
    {
        document.getElementById('projectionTable').style = "position:static; margin:0 auto; margin:auto;margin-left: 2.7%; z-index: 100; text-align: center; background-color: white;";
        document.getElementById('timeMatricesTable').style = "text-align: center;margin:0 auto; margin:auto;margin-top: 0px;";
    }

}

function blockHierarchicalProjectionVisualization()
{
    var blockProjection = document.getElementById("blockProjectionVisualizationCheckBox").checked;
    if (blockProjection === true)
    {
        document.getElementById('projectionTable').style = "position:fixed;margin:0 auto; margin:auto; margin-left: 353px; z-index: 100; text-align: center; background-color: white;";
        document.getElementById('timeMatricesTable').style = "text-align: center;margin:0 auto; margin:auto;margin-top: 300px;";
    } else
    {
        document.getElementById('projectionTable').style = "position:static; margin:0 auto; margin:auto;margin-left: 353px; z-index: 100; text-align: center; background-color: white;";
        document.getElementById('timeMatricesTable').style = "text-align: center;margin:0 auto; margin:auto;margin-top: 0px;";
    }

}

function loadNews(labelX, labelY, nameAttribute, nameArea) {


    var name_attributes = ["drug_possession", "drug_traffic", "drug_seizure", "illegal_weapon_possession",
        "seized_firearms", "flagrant_issued", "offenders_detained_in_flagrante", "offenders_detained_on_warrant", "people_arrested_in_flagrante",
        "people_arrested_on_warrant", "prisons_issued", "recovered_vehicles", "police_inquiries"];

    var indexAttribute = -1;
    for (i = 0; i < name_attributes.length; i++) {
        if (nameAttribute === name_attributes[i]) {
            indexAttribute = i;
        }
    }

    if (indexAttribute !== -1) {
        var keyname_attributes = ["drogas", "drogas", "drogas", "armas", "armas",
            "flagrante", "flagrante", "mandado", "preso", "preso",
            "prisão", "veículo", "inquérito"];

        var keyname_attribute = keyname_attributes[indexAttribute];

        var year = labelX.split("-")[0];
        var month;
        if (labelY.indexOf("month") !== -1)
        {
            month = labelY.split(" ")[1];
        } else {
            month = labelX.split("-")[1];
        }
       
        //var url = "http://acervo.folha.uol.com.br/fsp/" + year + "/" + month + "/";//s%C3%A3o+paulo
        ///?utf8=✓&fsp=on&fdm=1&fdn=1&all_words=&phrase=entorpecentes&words=&without_words=&initial_date=01%2F12%2F02&final_date=30%2F12%2F02&date%5Bday%5D=&date%5Bmonth%5D=&date%5Byear%5D=&group_id=14&theme_id=2&commit.x=51&commit.y=9&commit=Enviar
        var url = "http://acervo.folha.uol.com.br/resultados/buscade_talhada/?utf8=%E2%9C%93&fsp=on&fdm=1&fdn=1&all_words="+ nameArea +
             "&phrase="  + keyname_attribute +"&words=&without_words=&initial_date=01%2F"+month+"%2F"+year+"&final_date=28%2F"+month+"%2F"+year+"&date%5Bday%5D=&date%5Bmonth%5D=&date%5Byear%5D=&group_id=0&theme_id=0&commit.x=51&commit.y=9&commit=Enviar";
                // alert(url);
        window.open(url, 'News-' + year + '-' + month+ '-'+ nameArea, 'height=900,width=800');
    }

}


function instanceProjection()
{
    var optionsSubsetAttributesSelected = $('#selectSubsetAttributesSelected option');

    var listSubsetAttributesSelected = $.map(optionsSubsetAttributesSelected, function (optionsSubsetAttributesSelected) {
        return optionsSubsetAttributesSelected.value;
    });


    if (listSubsetAttributesSelected.length === 0)
    {
        document.getElementById("successMessage").value = "Please select attributes to be explored.";
        document.getElementById("successMessage").style.color = "red";
        return;

    }

    var nameProjectionTechnique = $('#selectInstanceProjection').val();

    var idAttributeTarget = $('#selectListAttribute').val();

    if (idAttributeTarget === "" || idAttributeTarget === "select")
    {
        document.getElementById("successMessage").value = "Please select the attribute target.\n";
        document.getElementById("successMessage").style.color = "red";
        return;
    }

    var categorization = $('#selectListCategorization').val();
    if (categorization === "" || categorization === "select")
    {
        document.getElementById("successMessage").value = "Please the type of categorization.\n";
        document.getElementById("successMessage").style.color = "red";
        return;
    }

    //var similarity = $('#listSimilarity').val();
    var colorStrategy = $('#listColorBy').val();
    var selectStrategyProjection = $('#selectStrategyProjection').val();


    document.getElementById("successMessage").value = "";
    document.getElementById("successMessage").style.color = "black";

    var encodeNameProjectionTechnique = encodeURIComponent(nameProjectionTechnique);
    var encodeIdAttributeTarget = encodeURIComponent(idAttributeTarget);
    var encodeCategorization = encodeURIComponent(categorization);
  //  var encodeSimilarity = encodeURIComponent(similarity);
    var encodeColorStrategy = encodeURIComponent(colorStrategy);
    if (selectStrategyProjection === "hierarchical") {
        var url = "jsp/attributesImageTable/InstanceHierarchicalProjectionMap.jsp?nameProjectionTechnique=" +
                encodeNameProjectionTechnique + "&idAttributeTarget=" + encodeIdAttributeTarget + "&categorization=" + encodeCategorization
                + "&colorStrategy=" + encodeColorStrategy;
        window.open(url, 'Instance Projection', 'height=930,width=1500');

    } else {
        var url = "jsp/attributesImageTable/InstanceNonHierarchicalProjectionMap.jsp?nameProjectionTechnique=" +
                encodeNameProjectionTechnique + "&idAttributeTarget=" + encodeIdAttributeTarget + "&categorization=" + encodeCategorization
               + "&colorStrategy=" + encodeColorStrategy;
        window.open(url, 'Instance Projection', 'height=930,width=1500');

    }

}
function visualizeNormalizedTimeSeriesButton()
{
     var url = "jsp/attributesImageTable/NormalizedTimeSeries.jsp";
        window.open(url, 'Normalized Aggregated Time Series', 'height=800,width=1000');
}


function categoriesSource1ProjectionButton()
{
     var url = "jsp/attributesImageTable/AttributeProjectionByCategory.jsp";
        window.open(url, 'Attribute Projection By Category', 'height=280,width=1200');
}