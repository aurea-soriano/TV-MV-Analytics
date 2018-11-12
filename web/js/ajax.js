/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function createVisualization(thresholdName, source1Name, source2Name)
{


    document.getElementById("successMessage").value = "Processing...";
    var selectedAttributes = new Array();
    if ($('#selectedAttributesCheckbox') !== null) {
        $("input[name='selectedAttributesCheckbox']:checked").each(function ()
        {
            selectedAttributes.push(($(this).val()));
        });
    }

    if (selectedAttributes === null || selectedAttributes.length === 0) {
        //alert("Please select the attributes to visualize.");
        document.getElementById("successMessage").value = "Please select the attributes to visualize.";
        document.getElementById("successMessage").style.color = "red";
        return;
    }

    var fromDate = $('#fromDate').val();
    var toDate = $('#toDate').val();

    if (fromDate === "" || toDate === "") {
        //alert("Please select date.");
        document.getElementById("successMessage").value = "Please select date.";
        document.getElementById("successMessage").style.color = "red";
        return;
    }
    var fromDateTest = null;
    var toDateTest = null;
    var fromDateArray = fromDate.split("-");
    fromDateTest = new Date(fromDateArray[0], fromDateArray[1], fromDateArray[2]);
    fromDate = fromDateArray[0] + "-" + fromDateArray[1] + "-" + fromDateArray[2];

    var toDateArray = toDate.split("-");


    toDateTest = new Date(toDateArray[0], toDateArray[1], toDateArray[2]);
    toDate = toDateArray[0] + "-" + toDateArray[1] + "-" + toDateArray[2];


    if (fromDateTest !== null && toDateTest !== null) {
        if (fromDateTest > toDateTest) {
            //alert("The first date is after the second date.");
            document.getElementById("successMessage").value = "The first date is after the second date.";
            document.getElementById("successMessage").style.color = "red";
            return;
        }
    }

    // var intervalTimes = new Array();
    // if (document.getElementById("listIntervalsSelect") !== null) {

    //   var listIntervalsSelect = document.getElementById("listIntervalsSelect");
    //    var numberIntervals = listIntervalsSelect.length;

    //    for (i = 0; i < numberIntervals; i++) {
    //        intervalTimes.push(listIntervalsSelect.options[i].value);
    //     }
    // }
    // if (intervalTimes === null || intervalTimes.length === 0) {
    //alert("Please add time intervals.");
    //    document.getElementById("successMessage").value = "Please add time intervals.";
    //     document.getElementById("successMessage").style.color = "red";
    //     return;
    //  }

    var unitTimeInterval = $('#selectUnitTimeInterval').val();
    var valueUnitTimeInterval = $('#valueUnitTimeInterval').val();

    var valueThreshold = $('#valueThreshold').val();

    if (valueThreshold === "")
    {
        document.getElementById("successMessage").value = "Please select an " + thresholdName + ".";
        document.getElementById("successMessage").style.color = "red";
        return;
    }

    if (valueUnitTimeInterval === "")
    {
        document.getElementById("successMessage").value = "Please select an unit of time interval.";
        document.getElementById("successMessage").style.color = "red";
        return;
    }

    if (unitTimeInterval === null)
    {
        document.getElementById("successMessage").value = "Please select an unit of time interval.";
        document.getElementById("successMessage").style.color = "red";
        return;
    }
    var source2String = "";


    if (source2Name !== null && source2Name !== "")
    {
        var listSource2 = $('#selectListSource2').val();
        source2String = listSource2.toString();
    }



    //var listSource1 = $('#selectListSource1').val();

    var selectListSource1 = $('#selectListSource1');
    var listSource1Category = [];
    var listSource1Individual = [];
    selectListSource1.find('optgroup').each(function () {
        var category = $(this);
        var options = category.children("option");
        var length = options.length;

        if (options.filter(":selected").length == length) {
            //all are selected, do something!
            listSource1Category.push(category.attr('label'));
        } else {
            //Not all selected, so push states
            options.filter(":selected").each(function () {
                listSource1Individual.push(this.value);
            });
        }



    });

    if (listSource1Category.length === 0 && listSource1Individual.length === 0)
    {
        document.getElementById("successMessage").value = "Please select the " + source1Name + ".";
        document.getElementById("successMessage").style.color = "red";
        return;
    }

    var source1CategoryString = listSource1Category.toString();
    var source1IndividualString = listSource1Individual.toString();

    /*
     var source1String = listSource1.toString();
     source1String = encodeURIComponent(source1String);
     if (listSource1 === null)
     {
     document.getElementById("successMessage").value = "Please select the " + source1Name + ".";
     document.getElementById("successMessage").style.color = "red";
     return;
     }*/

    var aggregationFunction = $('#selectAggregationFunction').val();
    if (aggregationFunction === null)
    {

        document.getElementById("successMessage").value = "Please select an aggregation function.";
        document.getElementById("successMessage").style.color = "red";
        return;
    }


    var messageNumberSelectedAttributes = document.getElementById('numberSelectedAttributesText').value;

    //var combineAllSource1DataFlag = document.getElementById('combineAllSource1DataCheckbox').checked;

    var selectListMoments = $('#selectListMoments').val();
    var selectedMoment = selectListMoments.toString();

    var selectListSimilarity = $('#selectListSimilarity').val();
    var selectedSimilarity = selectListSimilarity.toString();
    $.ajax({
        url: "jsp/QueryWindow.jsp",

        data: {
            queryUser: "true",
            selectedAttributes: selectedAttributes.toString(),
            source2: source2String,
            //source1: source1String,
            source1CategoryString: source1CategoryString,
            source1IndividualString: source1IndividualString,
            fromDate: fromDate,
            toDate: toDate,
            // intervalTimes: intervalTimes.toString(),
            unitTimeInterval: unitTimeInterval,
            valueUnitTimeInterval: valueUnitTimeInterval,
            valueThreshold: valueThreshold,
            aggregationFunction: aggregationFunction,
            messageNumberSelectedAttributes: messageNumberSelectedAttributes,
            //combineAllSource1DataFlag: combineAllSource1DataFlag
            selectedMoment: selectedMoment,
            selectedSimilarity: selectedSimilarity
        },
        success: function (data) {
            $("#main_frame").html(data);
        }
    });
}

function clearMessage() {

    document.getElementById("successMessage").style.color = "black";
    document.getElementById("successMessage").value = "";
}





function activeMenu(option)
{
    //document.getElementById('newConfiguration').className = "inactive";
    document.getElementById('initialMenu').className = "inactive";
    document.getElementById('homeMenu').className = "inactive";
    document.getElementById('matrixAttributesMenu').className = "inactive";
    document.getElementById('hierarchicalMatrixAttributesMenu').className = "inactive";
    document.getElementById('clusterExploration').className = "inactive";
    document.getElementById('subsetAttributesExploration').className = "inactive";
    document.getElementById('evaluationSubsetAttributes').className = "inactive";
    document.getElementById('attributePrediction').className = "inactive";
    document.getElementById('behaviorAnalysis').className = "inactive";
    document.getElementById('instanceProjection').className = "inactive";
    document.getElementById('timeCircularMenu').className = "inactive";

    document.getElementById(option).className = "active";

    if (option === 'initialMenu') {
        $.ajax({
            url: "jsp/InitialView.jsp",
            data: {
            },
            success: function (data) {
                $("#main_frame").html(data);
            }
        });
    } else {
        //  if (option === 'newConfiguration') {
        // window.location.href = "NewConfiguration.jsp";
        /* $.ajax({
         url: "jsp/NewConfiguration.jsp",
         data: {
         },
         success: function (data) {
         $("#main_frame").html(data);
         }
         });*/
        // } else {
        if (option === 'homeMenu') {
            $.ajax({
                url: "jsp/QueryWindow.jsp",
                data: {
                },
                success: function (data) {
                    $("#main_frame").html(data);
                }
            });
        } else {
            if (option === 'matrixAttributesMenu') {
                $.ajax({
                    url: "jsp/AttributesImageTable.jsp",
                    data: {
                    },
                    success: function (data) {
                        $("#main_frame").html(data);
                    }
                });
            } else
            {
                if (option === 'clusterExploration') {
                    $.ajax({
                        url: "jsp/ClusterVisualization.jsp",
                        data: {
                        },
                        success: function (data) {
                            $("#main_frame").html(data);
                        }
                    });

                } else
                {
                    if (option === 'subsetAttributesExploration') {
                        $.ajax({
                            url: "jsp/SubsetAttributesExploration.jsp",
                            data: {
                            },
                            success: function (data) {
                                $("#main_frame").html(data);
                            }
                        });
                    } else {
                        if (option === 'evaluationSubsetAttributes')
                        {
                            $.ajax({
                                url: "jsp/EvaluationSubsetAttributes.jsp",
                                data: {
                                },
                                success: function (data) {
                                    $("#main_frame").html(data);
                                }
                            });
                        } else {
                            if (option === 'attributePrediction')
                            {
                                $.ajax({
                                    url: "jsp/AttributePrediction.jsp",
                                    data: {
                                    },
                                    success: function (data) {
                                        $("#main_frame").html(data);
                                    }
                                });
                            } else
                            {
                                if (option === "behaviorAnalysis")
                                {
                                    $.ajax({
                                        url: "jsp/BehaviorAnalysis.jsp",
                                        data: {
                                        },
                                        success: function (data) {
                                            $("#main_frame").html(data);
                                        }
                                    });
                                } else {
                                    if (option === "instanceProjection") {
                                        $.ajax({
                                            url: "jsp/InstanceProjection.jsp",
                                            data: {
                                            },
                                            success: function (data) {
                                                $("#main_frame").html(data);
                                            }
                                        });
                                    } else {
                                        if (option === "hierarchicalMatrixAttributesMenu") {
                                            $.ajax({
                                                url: "jsp/HierarchicalAttributesImageTable.jsp",
                                                data: {
                                                },
                                                success: function (data) {
                                                    $("#main_frame").html(data);
                                                }
                                            });
                                        } else {
                                            if (option === "timeCircularMenu") {
                                                $.ajax({
                                                    url: "jsp/TimeCircularTimeMatrices.jsp",
                                                    data: {
                                                    },
                                                    success: function (data) {
                                                        $("#main_frame").html(data);
                                                    }
                                                });
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // }
                }
            }
        }
    }

}

function createClusterVisualization(option)
{
    var nameClusterVisualization = $('input[name="clusterExplorationRadio"]:checked').val();
    $.ajax({
        url: "jsp/clusterVisualizations/" + nameClusterVisualization + ".jsp",
        data: {
        },
        success: function (data) {
            $("#ClusterVisualizationContent").html(data);
        }
    });
}

function createSubsetAttributesVisualization(option)
{
    var nameSubsetAttributesVisualization = $('input[name="subsetAttributesExplorationRadio"]:checked').val();
    $.ajax({
        url: "jsp/subsetAttributesVisualizations/" + nameSubsetAttributesVisualization + ".jsp",
        data: {
        },
        success: function (data) {
            $("#SubsetAttributesVisualizationContent").html(data);
        }
    });
}

function filterClusteringSelection(option)
{


    var clustering = $('#selectClustering').val();

    if (clustering === "Xmeans")
    {

        $("#selectNumberClusters option[value='0']").prop('selected', true);
        // var numberClusters = $('#selectNumberClusters').val();
        $("#selectNumberClusters").prop("disabled", true);


    } else
    {
        $("#selectNumberClusters").prop("disabled", false);
    }

}


function removeTimeMatrix(idAttribute, nameAttribute)
{
    var result = confirm("Do you want to remove the variable "+nameAttribute+"?");
if (result) {
    var clustering = $('#selectClustering').val();
    var projection = $('#selectProjection').val();

    var numberClusters = $('#selectNumberClusters').val();
    if (numberClusters === "0" && clustering !== "Xmeans") {
        //alert("Please select a number of clusters greater then 0.");
        document.getElementById("successMessage").value = "Please select a number of clusters greater then 0.";
        document.getElementById("successMessage").style.color = "red";
        return;
    }

    if (clustering === null)
    {
        //alert("Please select a clustering algorithm.");
        document.getElementById("successMessage").value = "Please select a clustering algorithm.";
        document.getElementById("successMessage").style.color = "red";
        return;
    }
    $.ajax({
        url: "jsp/AttributesImageTable.jsp",
        data: {
            removeId: idAttribute,
              clustering: clustering,
            projection: projection,
            numberClusters: numberClusters,
            optionClustering: "reclustering"

        },
        success: function (data) {
            $("#AttributeMatricesContent").html(data);
        }
    });
    }
}


function addRemoveAttributeSubsetSelection(idAttribute)
{
    $.ajax({
        url: "jsp/SelectedAttributesSubset.jsp",
        data: {
            idAttribute: idAttribute
        },
        success: function (data) {
            $("#attributes_subset_frame").html(data);
        }
    });


}


function addRemoveAttributeSubsetSelection2(idAttribute)
{
    $.ajax({
        url: "jsp/SelectedAttributesSubset.jsp",
        data: {
            idAttribute: idAttribute
        },
        success: function (data) {
            $("#attributes_subset_frame2").html(data);
        }
    });


}

function addRemoveAttributeSubsetSelection5(idAttribute)
{
    $.ajax({
        url: "jsp/SelectedAttributesSubset.jsp",
        data: {
            idAttribute: idAttribute
        },
        success: function (data) {
            $("#attributes_subset_frame5").html(data);
        }
    });


}


function addRemoveAttributeSubsetSelection3(idAttribute)
{
    var currentLinkArray = window.location.href;
    currentLinkArray = currentLinkArray.split("#");
    var currentWindow = currentLinkArray[1];

    if (currentWindow === "matrixAttributesMenu") {
        var statusChecked = document.getElementById("selectedAttributeCheckBox" + idAttribute).checked;
        if (statusChecked === false) {
            document.getElementById("selectedAttributeCheckBox" + idAttribute).checked = true;
        } else
        {
            document.getElementById("selectedAttributeCheckBox" + idAttribute).checked = false;

        }

        $.ajax({
            url: "jsp/SelectedAttributesSubset.jsp",
            data: {
                idAttribute: idAttribute
            },
            success: function (data) {
                $("#attributes_subset_frame").html(data);
            }
        });
    } else
    {
        if (currentWindow === "clusterExploration")
        {
            $.ajax({
                url: "jsp/SelectedAttributesSubset.jsp",
                data: {
                    idAttribute: idAttribute
                },
                success: function (data) {
                    $("#attributes_subset_frame2").html(data);
                }
            });
        } else
        {
            if (currentWindow === "subsetAttributesExploration") {
                $.ajax({
                    url: "jsp/SelectedAttributesSubset.jsp",
                    data: {
                        idAttribute: idAttribute
                    },
                    success: function (data) {
                        $("#attributes_subset_frame5").html(data);
                    }
                });
            } else {
                if (currentWindow === "evaluationSubsetAttributes")
                {
                    $.ajax({
                        url: "jsp/SelectedAttributesSubset.jsp",
                        data: {
                            idAttribute: idAttribute
                        },
                        success: function (data) {
                            $("#attributes_subset_frame4").html(data);
                        }
                    });
                }
            }
        }
    }


}


function addRemoveAttributeSubsetSelectionFromList(attributeName)
{

    var currentLinkArray = window.location.href;
    currentLinkArray = currentLinkArray.split("#");
    var currentWindow = currentLinkArray[1];

    if (currentWindow === "matrixAttributesMenu") {
        var listIndices = $('#listIndicesString').val();
        var arrayIndices = listIndices.split(",");

        for (i = 0; i < arrayIndices.length; i++) {
            var index = arrayIndices[i];
            var indexName = $('#attributeName' + index).val();
            var indexSource1 = $('#attributeSource1' + index).val();
            var identifier = indexName + "-" + indexSource1;
            if (identifier === attributeName) {
                document.getElementById("selectedAttributeCheckBox" + index).checked = false;
            }
        }
        $.ajax({
            url: "jsp/SelectedAttributesSubset.jsp",
            data: {
                attributeName: attributeName
            },
            success: function (data) {
                $("#attributes_subset_frame").html(data);
            }
        });
    } else
    {
        if (currentWindow === "clusterExploration")
        {
            $.ajax({
                url: "jsp/SelectedAttributesSubset.jsp",
                data: {
                    attributeName: attributeName
                },
                success: function (data) {
                    $("#attributes_subset_frame2").html(data);
                }
            });
        } else
        {
            if (currentWindow === "subsetAttributesExploration") {
                $.ajax({
                    url: "jsp/SelectedAttributesSubset.jsp",
                    data: {
                        attributeName: attributeName
                    },
                    success: function (data) {
                        $("#attributes_subset_frame5").html(data);
                    }
                });
            } else {
                if (currentWindow === "evaluationSubsetAttributes")
                {
                    $.ajax({
                        url: "jsp/SelectedAttributesSubset.jsp",
                        data: {
                            attributeName: attributeName
                        },
                        success: function (data) {
                            $("#attributes_subset_frame4").html(data);
                        }
                    });
                }
            }
        }
    }


}
function loadTechniqueEvaluation(option)
{
    var strategyEvaluation = $('#selectEvaluationOption').val();

    $.ajax({
        url: "jsp/classificationOptions/TechniqueEvaluation.jsp",
        data: {
            strategyEvaluation: strategyEvaluation
        },
        success: function (data) {
            $("#techniqueEvaluationByEvaluationOptionContent").html(data);
        }
    });
    loadDescriptionCategorizationByScintillationType();

}

function loadCategorizationAndAttributesEvaluation(option)
{
    var scintillationType = $('#selectScintillationType').val();

    $.ajax({
        url: "jsp/classificationOptions/CategorizationByScintillationType.jsp",
        data: {
            scintillationType: scintillationType
        },
        success: function (data) {
            $("#categorizationByScintillationTypeContent").html(data);
        }
    });


    $.ajax({
        url: "jsp/classificationOptions/CategorizedAttributeByScintillationType.jsp",
        data: {
            scintillationType: scintillationType
        },
        success: function (data) {
            $("#categorizedAttributeByScintillationTypeContent").html(data);
        }
    });

    loadDescriptionCategorizationByScintillationType();
}

function loadDescriptionCategorizationByScintillationType(option)
{
    var scintillationType = $('#selectScintillationType').val();
    var categorization = $('#selectCategorizationByScintillationType').val();
    $.ajax({
        url: "jsp/classificationOptions/DescriptionScintillationCategorization.jsp",
        data: {
            categorization: categorization,
            scintillationType: scintillationType
        },
        success: function (data) {
            $("#descriptionCategorizationByScintillationTypeContent").html(data);
        }
    });

}
function showAttributeTargetBehavior() {
    var attributeTarget = $('#listAttributeTarget').val();
    if (attributeTarget !== null && attributeTarget !== "select") {
        $.ajax({
            url: "jsp/instanceProjection/AttributeTargetBehaviorContent.jsp",
            data: {
                attributeTarget: attributeTarget
            },
            success: function (data) {
                $("#attributeTargetBehaviorContent").html(data);
            }
        });
    }
}
function behaviorAnalysis()
{
    var listAttributes = $('#listAttributes').val();
    if (listAttributes === null)
    {
        alert("Please select attributes to be explored.");
        return;
    }
    var backgroundColor = $('#listBackgroundColor').val();
    $.ajax({
        url: "jsp/behaviorAnalysis/BehaviorAnalysisContent.jsp",
        data: {
            listAttributes: listAttributes.toString(),
            backgroundColor: backgroundColor
        },
        success: function (data) {
            $("#behaviorAnalysisContent").html(data);
        }
    });
}


function normalizedTimeSeries()
{

    var backgroundColor = $('#listBackgroundColor').val();
    $.ajax({
        url: "NormalizedTimeSeriesContent.jsp",
        data: {
            backgroundColor: backgroundColor
        },
        success: function (data) {
            $("#normalizedTimeSeriesContent").html(data);
        }
    });
}

function evaluateAttributesSubset()
{

    var optionsSubsetAttributesSelected = $('#selectSubsetAttributesSelected option');

    var listSubsetAttributesSelected = $.map(optionsSubsetAttributesSelected, function (optionsSubsetAttributesSelected) {
        return optionsSubsetAttributesSelected.value;
    });


    if (listSubsetAttributesSelected.length === 0)
    {
        document.getElementById("successMessage").value = "Please select attributes to be evaluated.";
        document.getElementById("successMessage").style.color = "red";
        return;

    }

    var evaluationOption = $('#selectEvaluationOption').val();


    var techniqueEvaluation = $('#selectTechniqueEvaluation').val();
    if (techniqueEvaluation === undefined || techniqueEvaluation === "select")
    {
        document.getElementById("successMessage").value = "Please select a strategy and a  technique of evaluation.";
        document.getElementById("successMessage").style.color = "red";
        return;
    }

    var categorization = $('#selectListCategorization').val();
    if (evaluationOption === "classification" && (categorization === undefined || categorization === "select"))
    {
        document.getElementById("successMessage").value = "Please select a type of categorization to be used.";
        document.getElementById("successMessage").style.color = "red";
        return;
    } else {
        if (evaluationOption !== "classification") {
            // remove "selected" from any options that might already be selected
            $('#selectListCategorization option[selected="selected"]').each(
                    function () {
                        $(this).removeAttr('selected');
                    }
            );


// mark the first option as selected
            $("#selectListCategorization option:first").attr('selected', 'selected');
            categorization = $('#selectListCategorization').val();
            $("#descriptionCategorization").val("");
        }
    }
    var attributeTarget = $('#selectAttributeTarget').val();
    if (attributeTarget === undefined || attributeTarget === "select")
    {
        document.getElementById("successMessage").value = "Please select an attribute target.";
        document.getElementById("successMessage").style.color = "red";
        return;
    }



    for (i = 0; i < listSubsetAttributesSelected.length; i++) {

        if (listSubsetAttributesSelected[i] === attributeTarget)
        {
            var errorMessage = "The attribute " + attributeTarget;

            errorMessage += " can not be used in the evaluation, since it is beging used as attribute target.";
            document.getElementById("successMessage").value = errorMessage;
            document.getElementById("successMessage").style.color = "red";
            return;
        }


    }


    var normalizedData = $('#normalizedDataCheckbox').prop('checked');
    document.getElementById("successMessage").value = "Processing...";
    document.getElementById("successMessage").style.color = "black";


    $.ajax({
        url: "jsp/classificationOptions/EvaluationResult.jsp",
        data: {
            subsetAttributesSelected: listSubsetAttributesSelected.toString(),
            evaluationOption: evaluationOption,
            techniqueEvaluation: techniqueEvaluation,
            categorization: categorization,
            attributeTarget: attributeTarget,
            normalizedData: normalizedData
        },
        success: function (data) {
            $("#successMessageContent").html(data);
        }
    });
}

function updateProjectionCluster(option)
{
    var nameProjectionTechnique = $('#selectProjectionCluster').val();
    $.ajax({
        url: "jsp/clusterVisualizations/GeneralProjection.jsp",
        data: {
            nameProjectionTechnique: nameProjectionTechnique
        },
        success: function (data) {
            $("#ClusterVisualizationContent").html(data);
        }
    });
}
function updateHierarchicalInstancesProjection(option) {

    var hierarchicalInstanceLevelRange = document.getElementById("hierarchicalInstanceLevelRange").value;
    $.ajax({
        url: "jsp/instanceProjection/InstanceHierarchicalProjectionMapAjax.jsp",
        data: {
            hierarchicalInstanceLevelRange: hierarchicalInstanceLevelRange
        },
        success: function (data) {
            $("#instanceProjectionMapContent").html(data);
        }
    });

}
function updateHierarchicalProjection(option) {

    var hierarchicalLevelRange = document.getElementById("hierarchicalLevelRange").value;
    $.ajax({
        url: "jsp/clusterVisualizations/HierarchicalProjection.jsp",
        data: {
            hierarchicalLevelRange: hierarchicalLevelRange
        },
        success: function (data) {
            $("#ClusterVisualizationContent").html(data);
        }
    });

}

function updateHierarchicalProjectionMatrices(option) {

    var hierarchicalLevelRange = document.getElementById("hierarchicalLevelRange").value;
    $.ajax({
        url: "jsp/attributesImageTable/HierarchicalProjection.jsp",
        data: {
            hierarchicalLevelRange: hierarchicalLevelRange
        },
        success: function (data) {
            $("#generalProjectionContent").html(data);
        }
    });

}

function updateHierarchicalProjectionByCategory(option) {

    var hierarchicalLevelRange = document.getElementById("hierarchicalLevelRange").value;
    $.ajax({
        url: "AttributeProjectionByCategoryContent.jsp",
        data: {
            hierarchicalLevelRange: hierarchicalLevelRange
        },
        success: function (data) {
            $("#generalProjectionContentCategory").html(data);
        }
    });

}

function updateHierarchicalProjectionHierarchicalMatrices(option) {

    var hierarchicalLevelRange = document.getElementById("hierarchicalLevelRange").value;
    $.ajax({
        url: "jsp/hierarchicaltimematrices/HierarchicalProjection.jsp",
        data: {
            hierarchicalLevelRange: hierarchicalLevelRange
        },
        success: function (data) {
            $("#generalProjectionContent").html(data);
        }
    });

}


function messageAddRemoveAttributeCluster(option1, option2, id1, id2)
{
    $("#RadioCorrelationClusterAttribute1").val(id1);
    $("#LabelCorrelationClusterAttribute1").text(option1);
    $("#RadioCorrelationClusterAttribute2").val(id2);
    $("#LabelCorrelationClusterAttribute2").text(option2);
    $("#dialog-form").dialog({
        resizable: false,
        height: 230,
        width: 400,
        modal: true,
        buttons: {
            "Add or Remove": function () {
                var selectedVal = "";
                var selected = $("input[type='radio'][name='RadioCorrelationClusterAttribute']:checked");
                if (selected.length > 0) {
                    selectedVal = selected.val();

                    addRemoveAttributeSubsetSelection2(selectedVal);
                } else
                {
                    alert("Select an attribute to add or remove.");
                }
                $(this).dialog("close");
            },
            Cancel: function () {
                $(this).dialog("close");
            }
        }
    });
}

function messageAddRemoveAttributeSubset(option1, option2)
{
    $("#RadioCorrelationSubsetAttribute1").val(option1);
    $("#LabelCorrelationSubsetAttribute1").text(option1);
    $("#RadioCorrelationSubsetAttribute2").val(option2);
    $("#LabelCorrelationSubsetAttribute2").text(option2);
    $("#dialog-form").dialog({
        resizable: false,
        height: 230,
        width: 400,
        modal: true,
        buttons: {
            "Add or Remove": function () {
                var selectedVal = "";
                var selected = $("input[type='radio'][name='RadioCorrelationSubsetAttribute']:checked");
                if (selected.length > 0) {
                    selectedVal = selected.val();
                    addRemoveAttributeSubsetSelection5(selectedVal);
                } else
                {
                    alert("Select an attribute to add or remove.");
                }
                $(this).dialog("close");
            },
            Cancel: function () {
                $(this).dialog("close");
            }
        }
    });
}
function processAttributePrediction(option)
{
    var predictedAttributeId = $('#listAttributesSelect').val();
    var techniquePrediction = $('#techniquePredictionSelect').val();
    $.ajax({
        url: "jsp/attributePrediction/AttributePredictionContent.jsp",
        data: {
            predictedAttributeId: predictedAttributeId,
            techniquePrediction: techniquePrediction
        },
        success: function (data) {
            $("#attributePredictionContent").html(data);
        }
    });

}

function updateMatrixCluster(numberCluster)
{
    var attributeData = $('#listAttributesSelect' + numberCluster).val().toString();
    var indexId = attributeData.lastIndexOf("_");
    var idTimeMatrix = attributeData.substring(indexId + 1, attributeData.length);

    $.ajax({
        url: "jsp/clusterVisualizations/ItemMatrixCluster.jsp",
        data: {
            idTimeMatrix: idTimeMatrix
        },
        success: function (data) {
            $("#Cluster" + numberCluster).html(data);
        }
    });

}

function reClustering(option)
{
    var clustering = $('#selectClustering').val();
    var projection = $('#selectProjection').val();

    var numberClusters = $('#selectNumberClusters').val();
    if (numberClusters === "0" && clustering !== "Xmeans") {
        //alert("Please select a number of clusters greater then 0.");
        document.getElementById("successMessage").value = "Please select a number of clusters greater then 0.";
        document.getElementById("successMessage").style.color = "red";
        return;
    }

    if (clustering === null)
    {
        //alert("Please select a clustering algorithm.");
        document.getElementById("successMessage").value = "Please select a clustering algorithm.";
        document.getElementById("successMessage").style.color = "red";
        return;
    }

    $.ajax({
        url: "jsp/AttributesImageTable.jsp",
        data: {
            clustering: clustering,
            projection: projection,
            numberClusters: numberClusters,
            optionClustering: "reclustering"

        },
        success: function (data) {
            $("#AttributeMatricesContent").html(data);
        }
    });
}


function representativeStrategyButton(option)
{
    var representativeStrategy = $('#representativeStrategy').val();
    if (representativeStrategy === "select") {
        document.getElementById("successMessage").value = "Please select a strategy of representatives.";
        document.getElementById("successMessage").style.color = "red";
        return;
    }
    var numRepresentatives = null;

    if (representativeStrategy === "medoids") {
        numRepresentatives = $('#numRepresentative').val();
        if (numRepresentatives === "select") {
            document.getElementById("successMessage").value = "Please select a number of medoids per cluster.";
            document.getElementById("successMessage").style.color = "red";
            return;
        }
    }

    var varTargetRepresentative = null;


    if ((representativeStrategy === "linearRegression") || (representativeStrategy === "simpleRegression")) {
        var varTargetRepresentative = $('#varTargetRepresentative').val();
        if (varTargetRepresentative === "select") {
            document.getElementById("successMessage").value = "Please select a variable target.";
            document.getElementById("successMessage").style.color = "red";
            return;
        }
    }



    $.ajax({
        url: "jsp/AttributesImageTable.jsp",
        data: {
            representativeStrategy: representativeStrategy,
            numRepresentatives: numRepresentatives,
            varTargetRepresentative: varTargetRepresentative
        },
        success: function (data) {
            $("#AttributeMatricesContent").html(data);
        }
    });




}

function reClusteringTimeCircular(option)
{
    var clustering = $('#selectClustering').val();
    var projection = $('#selectProjection').val();

    var numberClusters = $('#selectNumberClusters').val();
    if (numberClusters === "0" && clustering !== "Xmeans") {
        //alert("Please select a number of clusters greater then 0.");
        document.getElementById("successMessage").value = "Please select a number of clusters greater then 0.";
        document.getElementById("successMessage").style.color = "red";
        return;
    }

    if (clustering === null)
    {
        //alert("Please select a clustering algorithm.");
        document.getElementById("successMessage").value = "Please select a clustering algorithm.";
        document.getElementById("successMessage").style.color = "red";
        return;
    }

    $.ajax({
        url: "jsp/TimeCircularTimeMatrices.jsp",
        data: {
            clustering: clustering,
            projection: projection,
            numberClusters: numberClusters,
            optionClustering: "reclustering"

        },
        success: function (data) {
            $("#AttributeMatricesContent").html(data);
        }
    });
}

function reHierarchicalProjection(option)
{

    var projection = $('#selectProjection').val();
    var hierarchicalLevelRange = document.getElementById("hierarchicalLevelRange").value;
    $.ajax({
        url: "jsp/attributesImageTable/UpdateHierarchicalProjection.jsp",
        data: {
            hierarchicalLevelRange: hierarchicalLevelRange,
            projection: projection
        },
        success: function (data) {
            $("#generalProjectionContent").html(data);
        }
    });

}


function updateClusterInterval(listIdInterval, listOldCluster, listNewCluster)
{
    if (listIdInterval.length > 0) {
        $.ajax({
            url: "jsp/AttributesImageTable.jsp",
            data: {
                listIdInterval: listIdInterval.toString(),
                listOldCluster: listOldCluster.toString(),
                listNewCluster: listNewCluster.toString(),
                optionClustering: "updateclusters"


            },
            success: function (data) {
                $("#AttributeMatricesContent").html(data);
            }
        });
        reHierarchicalProjection();
    }
}


function updateClusterIntervalTimeCircular(listIdInterval, listOldCluster, listNewCluster)
{
    if (listIdInterval.length > 0) {
        $.ajax({
            url: "jsp/TimeCircularTimeMatrices.jsp",
            data: {
                listIdInterval: listIdInterval.toString(),
                listOldCluster: listOldCluster.toString(),
                listNewCluster: listNewCluster.toString(),
                optionClustering: "updateclusters"


            },
            success: function (data) {
                $("#AttributeMatricesContent").html(data);
            }
        });
        reHierarchicalProjection();
    }
}


function addIntervalExploration() {
    var initialValueInput = $('#initialValueInput').val();
    var finalValueInput = $('#finalValueInput').val();

    if (initialValueInput === "" || finalValueInput === "")
    {
        alert("Please select initial point and final point.");
        return;
    }
    var valueInterval = initialValueInput + " - " + finalValueInput;
    var match = false;
    if ($('#timeRangesSelect') !== null) {
        $('#timeRangesSelect option').each(function () {
            if (valueInterval === this.value)
                match = true;
        });
    }
    if (match)
    {
        alert("This time interval exists.");
        return;
    }
    $('#initialValueInput').val("");
    $('#finalValueInput').val("");
    $('#timeRangesSelect').append(
            $('<option></option>').html(valueInterval).val(valueInterval)
            );
}

function loadTargetAndCategorizationInstanceProjection() {

    var scintillationType = $('#listScintillationType').val();

    $.ajax({
        url: "jsp/instanceProjection/CategorizationContent.jsp",
        data: {
            scintillationType: scintillationType
        },
        success: function (data) {
            $("#categorizationContent").html(data);
        }
    });


    $.ajax({
        url: "jsp/instanceProjection/AttributeTargetContent.jsp",
        data: {
            scintillationType: scintillationType
        },
        success: function (data) {
            $("#attributeTargetContent").html(data);
        }
    });

    loadDescriptionCategorizationInstanceProjection();
}
function loadRepresentativeStrategyContent()
{
    var representativeStrategy = $('#representativeStrategy').val();

    $.ajax({
        url: "jsp/attributesImageTable/RepresentativeStrategyContent.jsp",
        data: {
            representativeStrategy: representativeStrategy
        },
        success: function (data) {
            $("#representativeStrategyContent").html(data);
        }
    });

}

function loadDescriptionCategorizationInstanceProjection()
{
    var categorization = $('#selectListCategorization').val();
    $.ajax({
        url: "jsp/instanceProjection/DescriptionCategorizationContent.jsp",
        data: {
            categorization: categorization
        },
        success: function (data) {
            $("#descriptionCategorizationContent").html(data);
        }
    });

}

function showProjectioSettings() {
    var scintillationType = $('#listScintillationType').val();

    var categorization = $('#listCategorization').val();
    var attributeTarget = $('#listAttributeTarget').val();

    if (scintillationType !== null && scintillationType !== "select" && categorization !== null && attributeTarget !== null && categorization !== "select" && attributeTarget !== "select") {
        $.ajax({
            url: "jsp/instanceProjection/InstanceProjectionSettings.jsp",
            data: {
                categorization: categorization,
                attributeTarget: attributeTarget
            },
            success: function (data) {
                $("#instanceProjectionSettingsContent").html(data);
            }
        });
    }
}



function createInstanceProjectionMap(option, thresholdName, source1Name, source2Name)
{
    var selectedAttributes = new Array();
    if ($('#selectedAttributesCheckbox') !== null) {
        $("input[name='selectedAttributesCheckbox']:checked").each(function ()
        {
            selectedAttributes.push(($(this).val()));
        });
    }

    if (selectedAttributes === null || selectedAttributes.length === 0) {
        //alert("Please select the attributes to visualize.");
        document.getElementById("successMessage").value = "Please select the attributes to project.\n";
        document.getElementById("successMessage").style.color = "red";
        return;

    }

    var fromDate = $('#fromDate').val();
    var toDate = $('#toDate').val();

    if (fromDate === "" || toDate === "") {
        //alert("Please select date.");
        document.getElementById("successMessage").value = "Please select date.\n";
        document.getElementById("successMessage").style.color = "red";
        return;

    }

    var fromDateTest = null;
    var toDateTest = null;
    var fromDateArray = fromDate.split("-");
    fromDateTest = new Date(fromDateArray[0], fromDateArray[1], fromDateArray[2]);
    fromDate = fromDateArray[0] + "-" + fromDateArray[1] + "-" + fromDateArray[2];

    var toDateArray = toDate.split("-");


    toDateTest = new Date(toDateArray[0], toDateArray[1], toDateArray[2]);
    toDate = toDateArray[0] + "-" + toDateArray[1] + "-" + toDateArray[2];


    if (fromDateTest !== null && toDateTest !== null) {
        if (fromDateTest > toDateTest) {
            //alert("The first date is after the second date.");
            document.getElementById("successMessage").value = "The first date is after the second date.\n";
            document.getElementById("successMessage").style.color = "red";
            return;
        }
    }



    var valueThreshold = $('#valueThreshold').val();

    if (valueThreshold === "")
    {
        document.getElementById("successMessage").value = "Please select an " + thresholdName + ".";
        document.getElementById("successMessage").style.color = "red";
        return;
    }



    var source2String = "";


    if (source2Name !== null && source2Name !== "")
    {
        var listSource2 = $('#selectListSource2').val();
        source2String = listSource2.toString();
    }


    var listSource1 = $('#selectListSource1').val();
    var source1String = listSource1.toString();



    if (listSource1 === null)
    {
        document.getElementById("successMessage").value = "Please select the " + source1Name + ".";
        document.getElementById("successMessage").style.color = "red";
        return;
    }




    var attributeTarget = $('#selectListAttribute').val();

    if (attributeTarget === "" || attributeTarget === "select")
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

    var colorStrategy = $('#listColorBy').val();
    /* var filterValuesPercent = $('#filterValues').val();
     filterValuesPercent = replaceAll(filterValuesPercent, "%", "");
     var minValueFilter = filterValuesPercent.split("-")[0];
     var maxValueFilter = filterValuesPercent.split("-")[1];*/

    var nameProjectionTechnique = $('#selectProjection').val();



    var selectStrategyProjection = $('#selectStrategyProjection').val();

    var combineAllSource1DataFlag = document.getElementById('combineAllSource1DataCheckbox').checked;

    document.getElementById("successMessage").value = "";
    document.getElementById("successMessage").style.color = "black";
    if (selectStrategyProjection === "hierarchical") {

        $.ajax({
            url: "jsp/instanceProjection/InstanceHierarchicalProjectionMap.jsp",
            data: {
                queryUser: "true",
                selectedAttributes: selectedAttributes.toString(),
                source2: source2String,
                source1: source1String,
                fromDate: fromDate,
                toDate: toDate,
                // intervalTimes: intervalTimes.toString(),
                valueThreshold: valueThreshold,
                option: option,
                attributeTarget: attributeTarget,
                categorization: categorization,
                colorStrategy: colorStrategy,
                nameProjectionTechnique: nameProjectionTechnique,
                combineAllSource1DataFlag: combineAllSource1DataFlag

            },
            success: function (data) {
                $("#instanceProjectionMapSpace").html(data);
            }
        });
    } else {

        $.ajax({
            url: "jsp/instanceProjection/InstanceNonHierarchicalProjectionMap.jsp",
            data: {
                queryUser: "true",
                selectedAttributes: selectedAttributes.toString(),
                source2: source2String,
                source1: source1String,
                fromDate: fromDate,
                toDate: toDate,
                // intervalTimes: intervalTimes.toString(),
                valueThreshold: valueThreshold,
                option: option,
                attributeTarget: attributeTarget,
                categorization: categorization,
                similarity: similarity,
                colorStrategy: colorStrategy,
                nameProjectionTechnique: nameProjectionTechnique,
                combineAllSource1DataFlag: combineAllSource1DataFlag

            },
            success: function (data) {
                $("#instanceProjectionMapSpace").html(data);
            }
        });
    }
}

function filterNHPButton() {
    var minValueFilter = $("#minValueInput").val();
    var maxValueFilter = $("#maxValueInput").val();

    $.ajax({
        url: "jsp/instanceProjection/InstanceNonHierarchicalProjectionMapAjax.jsp",
        data: {
            minValueFilter: minValueFilter,
            maxValueFilter: maxValueFilter

        },
        success: function (data) {
            $("#instanceProjectionMapContent").html(data);
        }
    });
}
function updateHierarchicalInstanceProjectionButton(option) {

    var hierarchicalInstanceLevelRange = document.getElementById("hierarchicalInstanceLevelRange").value;
    $.ajax({
        url: "InstanceHierarchicalProjectionMapAjax.jsp",
        data: {
            hierarchicalInstanceLevelRange: hierarchicalInstanceLevelRange
        },
        success: function (data) {
            $("#instanceProjectionMapContent").html(data);
        }
    });

}

function filterNHPInstanceProjectionButton() {
    var minValueFilter = $("#minValueInput").val();
    var maxValueFilter = $("#maxValueInput").val();

    $.ajax({
        url: "InstanceNonHierarchicalProjectionMapAjax.jsp",
        data: {
            minValueFilter: minValueFilter,
            maxValueFilter: maxValueFilter

        },
        success: function (data) {
            $("#instanceProjectionMapContent").html(data);
        }
    });
}


function updateMissingDataThreshold(numberTimeMatrices)
{
    var missingDataThreshold = parseFloat($("#missingDataSlider").val());
    $("#missingDataThresholdInput").val(missingDataThreshold + "%");
    filterMissingDataButton(numberTimeMatrices, missingDataThreshold);

}
function updateHaarLevel()
{
    $("#missingDataSlider").val(100);
    $("#missingDataThresholdInput").val("100%");
    var haarLeveldSlider = parseFloat($("#haarLeveldSlider").val());
    $("#haarLeveldInput").val(haarLeveldSlider);

    var corrCoeffSlider = parseFloat($("#corrCoeffSlider").val());
    $("#corrCoeffInput").val(corrCoeffSlider);

    $.ajax({
        url: "jsp/TimeCircularTimeMatrices.jsp",
        data: {
            haarLevelRangeStr: haarLeveldSlider,
            corrCoeffStr: corrCoeffSlider
        },
        success: function (data) {
            $("#AttributeMatricesContent").html(data);
        }
    });

}

function updateCorrCoeff()
{
    $("#missingDataSlider").val(100);
    $("#missingDataThresholdInput").val("100%");
    var haarLeveldSlider = parseFloat($("#haarLeveldSlider").val());
    $("#haarLeveldInput").val(haarLeveldSlider);

    var corrCoeffSlider = parseFloat($("#corrCoeffSlider").val());
    $("#corrCoeffInput").val(corrCoeffSlider);

    $.ajax({
        url: "jsp/TimeCircularTimeMatrices.jsp",
        data: {
            haarLevelRangeStr: haarLeveldSlider,
            corrCoeffStr: corrCoeffSlider
        },
        success: function (data) {
            $("#AttributeMatricesContent").html(data);
        }
    });

}

function updateSubGroupSize()
{
    $("#missingDataSlider").val(100);
    $("#missingDataThresholdInput").val("100%");
    $("#haarLeveldInput").val(0);
    var subGroupSizeStr = parseInt($("#subGroupSizeInput").val());

    $.ajax({
        url: "jsp/TimeCircularTimeMatrices.jsp",
        data: {
            haarLevelRangeStr: 0,
            subGroupSizeStr: subGroupSizeStr
        },
        success: function (data) {
            $("#AttributeMatricesContent").html(data);
        }
    });

}

function filterMissingDataButton(numberTimeMatrices, missingDataThreshold) {
    // var maxMissingDataInput = parseFloat($("#maxMissingDataInput").val());
    // var minMissingDataInput = parseFloat($("#minMissingDataInput").val());


    for (i = 0; i < numberTimeMatrices; i++) {
        var value = parseFloat(document.getElementById("missingData" + i).value);
        var numVar = i;

        // if( (maxMissingDataInput>=value) && (minMissingDataInput<=value)) {
        if (missingDataThreshold <= value) {
            document.getElementById('matrix' + numVar).style.borderColor = "#28c8ff";
            var element = d3.select('#circle' + numVar);
            element.style('stroke', '#28c8ff').style("stroke-width", 2);
        } else {
            document.getElementById('matrix' + numVar).style.borderColor = "#A8A8A8";
            var element = d3.select('#circle' + numVar);
            element.style('stroke', 'black').style("stroke-width", 2);

        }
    }

}
function containsInteger(a, obj) {
    var i = a.length;
    while (i--) {
        if (parseInt(a[i]) === parseInt(obj)) {
            return true;
        }
    }
    return false;
}
function focusProjectionHierarchicalMembers(medoidId, matrixMedoidId, numberMembers, strinIds) {
    repaintPreviousBorderHierarchicalMembers();

    var element = d3.select('#circle' + matrixMedoidId);
    if (element !== null && !element.empty() && element !== "") {
        document.getElementById('idPreviousCircleAttribute').value = matrixMedoidId;
        document.getElementById('borderColorPreviousCircleAttribute').value = element.attr("stroke");
        element.style('stroke', 'red').style("stroke-width", 2);

    }

    var listIds = strinIds.split(",");
    var previousMedoidIds = "";
    var previousMedoidColors = "";
    var previousMemberIds = "";
    var previousMemberColors = "";

    previousMedoidIds = medoidId;
    previousMedoidColors = document.getElementById('matrixMedoid' + medoidId).style.borderColor;

    document.getElementById('previousMedoidIds').value = previousMedoidIds;
    document.getElementById('previousMedoidColors').value = previousMedoidColors;

    document.getElementById('matrixMedoid' + medoidId).style.borderColor = 'red';
    for (i = 0; i < numberMembers; i++) {
        var id = parseFloat(document.getElementById("idMember" + i).value);

        if (containsInteger(listIds, id))
        {
            previousMemberIds += i + ";";
            previousMemberColors += document.getElementById('matrixMember' + i).style.borderColor + ";";
            document.getElementById('matrixMember' + i).style.borderColor = 'red';

        }
    }

    previousMemberIds = previousMemberIds.substr(0, previousMemberIds.length - 1);
    previousMemberColors = previousMemberColors.substr(0, previousMemberColors.length - 1);

    document.getElementById('previousMemberIds').value = previousMemberIds;
    document.getElementById('previousMemberColors').value = previousMemberColors;

}

function repaintPreviousBorderHierarchicalMembers()
{
    var previousMedoidIds = document.getElementById('previousMedoidIds').value;
    var previousMedoidColors = document.getElementById('previousMedoidColors').value;

    if (previousMedoidIds !== null && previousMedoidColors !== null && previousMedoidIds !== "" && previousMedoidColors !== "") {
        document.getElementById('matrixMedoid' + previousMedoidIds).style.borderColor = previousMedoidColors;
    }
    document.getElementById('previousMedoidIds').value = "";
    document.getElementById('previousMedoidColors').value = "";

    var previousMemberIds = document.getElementById('previousMemberIds').value;
    var previousMemberColors = document.getElementById('previousMemberColors').value;



    var arrayPreviousMemberIds = previousMemberIds.split(";");
    var arrayPreviousMemberColors = previousMemberColors.split(";");
    for (i = 0; i < arrayPreviousMemberIds.length && i < arrayPreviousMemberColors.length; i++) {
        if (arrayPreviousMemberIds[i] !== null && arrayPreviousMemberColors[i] !== null && arrayPreviousMemberIds[i] !== "" && arrayPreviousMemberColors[i] !== "") {
            document.getElementById('matrixMember' + arrayPreviousMemberIds[i]).style.borderColor = arrayPreviousMemberColors[i];
        }
    }
    document.getElementById('previousMemberIds').value = "";
    document.getElementById('previousMemberColors').value = "";


}

function updateMissingDataThresholdHierarchical(numberMedoids, numberMembers, listMembers, listMedoids)
{
    var missingDataThreshold = parseFloat($("#missingDataSlider").val());
    $("#missingDataThresholdInput").val(missingDataThreshold + "%");
    filterMissingDataButtonHierarchical(numberMedoids, numberMembers, missingDataThreshold, listMembers, listMedoids);


}
function filterMissingDataButtonHierarchical(numberMedoids, numberMembers, missingDataThreshold, listMembers, listMedoids)
{

    var arrayMembers = JSON.parse(listMembers)
    var arrayMedoids = JSON.parse(listMedoids)





    for (i = 0; i < numberMedoids; i++) {
        var value = parseFloat(document.getElementById("missingDataMedoid" + i).value);
        var numVar = i;

        // if( (maxMissingDataInput>=value) && (minMissingDataInput<=value)) {
        if (missingDataThreshold <= value) {
            document.getElementById('matrixMedoid' + numVar).style.borderColor = "#28c8ff";


        } else {
            document.getElementById('matrixMedoid' + numVar).style.borderColor = "#A8A8A8";

        }
    }

    for (i = 0; i < numberMembers; i++) {
        var value = parseFloat(document.getElementById("missingDataMember" + i).value);
        var numVar = i;

        // if( (maxMissingDataInput>=value) && (minMissingDataInput<=value)) {
        if (missingDataThreshold <= value) {
            document.getElementById('matrixMember' + numVar).style.borderColor = "#28c8ff";
            var idMatrixMember = document.getElementById('idMember' + numVar).value;
            var element = d3.select('#circle' + idMatrixMember);
            element.style('stroke', '#28c8ff').style("stroke-width", 2);

        } else {
            document.getElementById('matrixMember' + numVar).style.borderColor = "#A8A8A8";
            var idMatrixMember = document.getElementById('idMember' + numVar).value;
            var element = d3.select('#circle' + idMatrixMember);
            if (element !== null && !element.empty() && element !== "") {
                var colorBorder = "";
                if (containsInteger(arrayMedoids, idMatrixMember) === true) {

                    var colorBorder = "black";
                } else {
                    if (containsInteger(arrayMembers, idMatrixMember) === true) {
                        var colorBorder = "dimGray";
                    } else {
                        var colorBorder = "white";
                    }
                }
                element.style('stroke', colorBorder);
                element.style("stroke-width", 2);
            }


        }
    }



}




function replaceAll(str, needle, replacement) {
    return str.split(needle).join(replacement);
}

function exploreHierarchicalTimeMatrices(explorationOption, seeallbool) {



    $.ajax({
        url: "jsp/HierarchicalAttributesImageTable.jsp",
        data: {
            explorationOption: explorationOption,
            seeallbool: seeallbool

        },
        success: function (data) {
            $("#HierarchicalAttributeMatricesContent").html(data);
        }
    });
}



function selectFileXML()
{
    $('#alertLoad').val('Please wait...');
    var nameXMLFile = $('#selectListXMLFile').val();
    $.ajax({
        url: "jsp/InitialView.jsp",
        data: {
            nameXMLFile: nameXMLFile
        },
        success: function (data) {
            $("#InitialViewContent").html(data);
        }
    });
}



function resultsSubsetTimeMatrices(option)
{
    try {
        $('#resultLRInput').val('');
        $('#resultMPInput').val('');
        $('#resultSVMInput').val('');
        $('#resultJ48Input').val('');
    } catch (err) {
    }
    var div = document.getElementById('classiferResultsContent');

    div.innerHTML = "Processing...";
    div.style.color = "#FF0000";
    div.style.textAlign = "center";


    $.ajax({
        url: "ClassifierResultsContent.jsp",
        data: {
            calculateResultsBoolean: option
        },
        success: function (data) {
            $("#classiferResultsContent").html(data);
        }
    });
}


function changeLayoutTimeMatrices()
{
    var layoutRadioButton = $('input[name="layoutRadioButton"]:checked').val();
    $.ajax({
        url: "jsp/AttributesImageTable.jsp",
        data: {
            layoutRadioButton: layoutRadioButton
        },
        success: function (data) {
            $("#AttributeMatricesContent").html(data);
        }
    });

}


function changeLayoutTimeMatrices()
{
    var layoutRadioButton = $('input[name="layoutRadioButton"]:checked').val();
    $.ajax({
        url: "jsp/AttributesImageTable.jsp",
        data: {
            layoutRadioButton: layoutRadioButton
        },
        success: function (data) {
            $("#AttributeMatricesContent").html(data);
        }
    });

}

function changeNumberCols()
{
    var numberCols = $("#numberColsInput").val();
    $.ajax({
        url: "jsp/AttributesImageTable.jsp",
        data: {
            numberCols: numberCols
        },
        success: function (data) {
            $("#AttributeMatricesContent").html(data);
        }
    });

}

function changeColorStyleVariableProjectionTimeCircular()
{
    var colorStyleRadioButton = $('input[name="colorStyleRadioButton"]:checked').val();
    $.ajax({
        url: "jsp/TimeCircularTimeMatrices.jsp",
        data: {
            colorStyleRadioButton: colorStyleRadioButton
        },
        success: function (data) {
            $("#AttributeMatricesContent").html(data);
        }
    });

}

function removeSpaces(nameInput)
{
    var inputStr = $('#' + nameInput).val();
    inputStr = inputStr.replace(/\s+/g, '');
    $('#' + nameInput).val(inputStr);

}

function loadCategorizationSpaces()
{
    var numberOfCategorizations = $('#numberOfCategorizations').val();
    $.ajax({
        url: "jsp/newConfiguration/CategorySpaces.jsp",
        data: {
            numberOfCategorizations: numberOfCategorizations
        },
        success: function (data) {
            $("#descriptionCategorization").html(data);
        }
    });

}