<div class="container-fluid" style="height: 20px;   margin:0 auto; margin:auto;"></div>
<table style="width:800px;    margin:0 auto; margin:auto;">
    <tr>
        <td>

            <div class="container-fluid" style="width:400px;    margin:0 auto; margin:auto;">
                <div class="well" style=" position:relative; ">
                    <table style="text-align: center;">
                        <tr>
                            <td style="width:  400px;text-align: center;" colspan="2">
                                <b>Connection</b>
                            </td>

                        </tr>
                        <tr>
                            <td style="height:  20px;text-align: center;" colspan="2">
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>IP server:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="ipServerInput" id="ipServerInput"><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Driver:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="driverInput" id="driverInput" value="org.postgresql.Driver"><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Prefix:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="prefixInput" id="prefixInput" value="jdbc:postgresql://"><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Port:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="portInput" id="portInput" value="5432"><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Database:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="databaseInput" id="databaseInput" value=""
                                       onkeyup="removeSpaces('databaseInput');"
                                       ><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>User:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="userInput" id="userInput" value=""
                                       onkeyup="removeSpaces('userInput');"
                                       ><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Password:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="password" name="passwordInput" id="passwordInput" value=""
                                       ><br>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

        </td>
        <td>

            <div class="container-fluid" style="width:400px;    margin:0 auto; margin:auto;">
                <div class="well" style=" position:relative; ">
                    <table style="text-align: center;">
                        <tr>
                            <td style="width:  400px;text-align: center;" colspan="2">
                                <b>Table of variables</b>
                            </td>

                        </tr>
                        <tr>
                            <td style="height:  20px;text-align: center;" colspan="2">
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Table Name:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="tablenameVariableInput" id="tablenameVariableInput"><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Id Field:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="idVariableInput" id="idVariableInput" value=""><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Name Field:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="nameVariableInput" id="nameVariableInput" value=""><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Category Field:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="categoryVariableInput" id="categoryVariableInput" value=""><br>
                            </td>
                        </tr>

                    </table>
                </div>
            </div>       
        </td>
    </tr>
    <tr>
        <td>
            <div class="container-fluid" style="width:400px;    margin:0 auto; margin:auto;">
                <div class="well" style=" position:relative; ">
                    <table style="text-align: center;">
                        <tr>
                            <td style="width:  400px;text-align: center;" colspan="2">
                                <b>Table of source 1</b>
                            </td>
                        </tr>
                        <tr>
                            <td style="height:  20px;text-align: center;" colspan="2">
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Table Name:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="tablenameSource1Input" id="tablenameSource1Input"><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Id Field:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="idSource1Input" id="idSource1Input" value=""><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Name Field:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="nameSource1Input" id="nameSource1Input" value=""><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Description Field:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="descriptionSource1Input" id="descriptionSource1Input" value=""><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Category Field:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="categorySource1Input" id="categorySource1Input" value=""><br>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>       
        </td>
        <td>
            <div class="container-fluid" style="width:400px;    margin:0 auto; margin:auto;">
                <div class="well" style=" position:relative; ">
                    <table style="text-align: center;">
                        <tr>
                            <td style="width:  400px;text-align: center;" colspan="2">
                                <b>Table of source 2 (Optional)</b>
                            </td>
                        </tr>
                        <tr>
                            <td style="height:  20px;text-align: center;" colspan="2">
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Table Name:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="tablenameSource2Input" id="tablenameSource2Input"><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Id Field:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="idSource2Input" id="idSource2Input" value=""><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Name Field:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="nameSource2Input" id="nameSource2Input" value=""><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Description Field:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="descriptionSource2Input" id="descriptionSource2Input" value=""><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Category Field:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="categorySource2Input" id="categorySource2Input" value=""><br>
                            </td>
                        </tr>

                    </table>
                </div>
            </div>       
        </td>
    </tr>
      <tr>

        <td>

            <div class="container-fluid" style="width:400px;    margin:0 auto; margin:auto;">
                <div class="well" style=" position:relative; ">
                    <table style="text-align: center;">
                        <tr>
                            <td style="width:  400px;text-align: center;" colspan="2">
                                <b>Table of instances</b>
                            </td>

                        </tr>
                        <tr>
                            <td style="height:  20px;text-align: center;" colspan="2">
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Table Name:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="tablenameInstanceInput" id="tablenameInstanceInput"><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Id Field:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="idInstanceInput" id="idInstanceInput" value=""><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Name of FK source1:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="source1InstanceInput" id="source1InstanceInput" value=""><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Name of FK source2 (Optional):</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="source2InstanceInput" id="source2InstanceInput" value=""><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Time Field:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="timeFieldInstanceInput" id="timeFieldInstanceInput" value=""><br>
                            </td>
                        </tr>

                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Var. Threshold Label:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="thresholdLabelInstanceInput" id="thresholdLabelInstanceInput" value=""><br>
                            </td>
                        </tr>
                         <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Var. Threshold Table:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <input type="text" name="thresholdTableInstanceInput" id="thresholdTableInstanceInput" value=""><br>
                            </td>
                        </tr>
                          <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Var. Threshold Options:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <select name="thresholdOptionsInstanceInput" 
                                       id="thresholdOptionsInstanceInput" multiple size="3" style="width:170px;">
                                    <%for(int i=0; i<=18; i++){%>
                                    <option value="<%=(i*10)%>"><%=(i*10)%></option>
                                    <%}%>
                                    
                                </select>
                               
                            </td>
                        </tr>



                    </table>
                </div>
            </div>       


        </td>
        <td>

            <div class="container-fluid" style="width:400px;    margin:0 auto; margin:auto;">
                <div class="well" style=" position:relative; ">
                    <table style="text-align: center;">
                        <tr>
                            <td style="width:  400px;text-align: center;" colspan="2">
                                <b>Aggregation details</b>
                            </td>

                        </tr>
                        <tr>
                            <td style="height:  20px;text-align: center;" colspan="2">
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Row unit:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <select name="rowUnitAggregationInput" 
                                       id="rowUnitAggregationInput" style="width:170px;">
                                   <option value="hour">hour</option>
                                   <option value="day">day</option>
                                   <option value="month">month</option>
                                   <option value="year">year</option>
                                </select>
                            </td>
                        </tr>
                         <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Time unit:</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <select name="timeUnitAggregationInput" 
                                       id="timeUnitAggregationInput"  multiple size="3"   style="width:170px;">
                                   <option value="hour">hour</option>
                                   <option value="day">day</option>
                                   <option value="month">month</option>
                                   <option value="year">year</option>
                                </select>
                            </td>
                        </tr>
                           <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Aggregation function(s):</b>
                            </td>
                            <td style="width:  200px;text-align: left;">
                                <select name="functionsAggregationInput" 
                                       id="functionsAggregationInput"  multiple size="3"   style="width:170px;">
                                   <option value="max">max</option>
                                   <option value="avg">avg</option>
                                   <option value="min">min</option>
                                   <option value="std">std</option>
                                   <option value="median">median</option>
                                </select>
                            </td>
                        </tr>
                       

                    </table>
                </div>
            </div>       
        </td>
    </tr>
    <tr>
        <td colspan="2">
            
            <div class="container-fluid" style="width:600px;    margin:0 auto; margin:auto;">
                <div class="well" style=" position:relative; ">
                    <table style="width:  600px;text-align: center;">
                        <tr>
                            <td style="text-align: center;" colspan="2">
                                <b>List of functions</b>
                            </td>

                        </tr>
                        <tr>
                            <td style="height:  20px;text-align: center;" colspan="2">
                            </td>
                        </tr>
                         <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Maximum:</b>
                            </td>
                            <td style="width:  400px;text-align: left;">
                                <input style="width:  300px;" 
                                       type="text" name="functionMaxInput" id="functionMaxInput" value=""><br>
                            </td>
                        </tr>
                         <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Minimum:</b>
                            </td>
                            <td style="width:  400px;text-align: left;">
                                <input style="width:  300px;" 
                                       type="text" name="functionMinInput" id="functionMinInput" value=""><br>
                            </td>
                        </tr>
                         <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Average:</b>
                            </td>
                            <td style="width:  400px;text-align: left;">
                                <input style="width:  300px;" 
                                       type="text" name="functionAvgInput" id="functionAvgInput" value=""><br>
                            </td>
                        </tr>
                         <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Std:</b>
                            </td>
                            <td style="width:  400px;text-align: left;">
                                <input style="width:  300px;" 
                                       type="text" name="functionStdInput" id="functionStdInput" value=""><br>
                            </td>
                        </tr>
                         <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Median:</b>
                            </td>
                            <td style="width:  400px;text-align: left;">
                                <input style="width:  300px;" 
                                       type="text" name="functionMedianInput" id="functionMedianInput" value=""><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Max with threshold:</b>
                            </td>
                            <td style="width:  400px;text-align: left;">
                                <input style="width:  300px;" 
                                       type="text" name="functionMaxThresholdInput" id="functionMaxThresholdInput" value=""><br>
                            </td>
                        </tr>
                         <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Min with threshold:</b>
                            </td>
                            <td style="width:  400px;text-align: left;">
                                <input style="width:  300px;" 
                                       type="text" name="functionMinThresholdInput" id="functionMinThresholdInput" value=""><br>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Average with threshold:</b>
                            </td>
                            <td style="width:  400px;text-align: left;">
                                <input style="width:  300px;" 
                                       type="text" name="functionAvgThresholdInput" id="functionAvgThresholdInput" value=""><br>
                            </td>
                        </tr>
                         <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Std with threshold:</b>
                            </td>
                            <td style="width:  400px;text-align: left;">
                                <input style="width:  300px;" 
                                       type="text" name="functionStdThresholdInput" id="functionStdThresholdInput" value=""><br>
                            </td>
                        </tr>
                         <tr>
                            <td style="width:  200px;text-align: right;">
                                <b>Median with threshold:</b>
                            </td>
                            <td style="width:  400px;text-align: left;">
                                <input style="width:  300px;" 
                                       type="text" name="functionMedianThresholdInput" id="functionMedianThresholdInput" value=""><br>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </td>
    </tr>
      <tr>
        <td colspan="2">
            
            <div class="container-fluid" style="width:600px;    margin:0 auto; margin:auto;">
                <div class="well" style=" position:relative; ">
                    <table style="width:  600px;text-align: center;">
                        <tr>
                            <td style="text-align: center;" colspan="2">
                                <b>Categorizations</b>
                            </td>

                        </tr>
                        <tr>
                            <td style="height:  20px;text-align: center;" colspan="2">
                            </td>
                        </tr>
                         <tr>
                            <td style="width:  200px;text-align: right;">
                                <b># of Categorizations:</b>
                            </td>
                            <td style="width:  400px;text-align: left;">
                                  <select name="numberOfCategorizations" 
                                       id="numberOfCategorizations" style="width:170px;"
                                       onchange="loadCategorizationSpaces()">
                                      <%for(int i=0;i<10; i++){%>
                                   <option value="<%=i%>"><%=i%></option>
                                   <%}%>
                                </select>
                            </td>
                        </tr>
                    </table>
                                
                        <div id="descriptionCategorization">
                            
                            
                        </div>
                </div>
            </div>
        </td>
    </tr>
    
    
    
    <tr>
    <tr style="height: 30px;">
    </tr>
    <tr>
        <td colspan="2" style="text-align: center;"><button  id="newEntryButton" name="newEntryButton"  
                                                             type="button"  onclick="
                newEntryButton();"><b>TODO:ProcessNewENtry</b></button></td>
    </tr>

</tr>
</table>