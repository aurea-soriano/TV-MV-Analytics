<%-- 
    Document   : AttributePrediction
    Created on : Apr 4, 2016, 6:20:56 PM
    Author     : aurea
--%>

<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>
<%
    ArrayList<TimeInterval> listTimeIntervalAttributes = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    if (listTimeIntervalAttributes != null) {

%>
<br>
<div class="container-fluid" style="width:320px; height: 80px;   margin:0 auto; margin:auto; text-align: center;">
    <div class="row">

        <div class="col-sm-2">
            <div class="well" style="width:320px; height: 80px;  position:relative; left: 2px;">
                <table>
                    <tr>
                        <td style="width:50%; text-align: right;" ><b>Attribute:</b></td><td style="width:50%">
                <select name="listAttributesSelect" id="listAttributesSelect"  style="width: 170px;" >
                    <%for (int i = 0; i < listTimeIntervalAttributes.size(); i++) {%>
                    <option value="<%=i%>"><%=listTimeIntervalAttributes.get(i).getNameAttribute()%></option>
                    <%}
                    %>
                </select></td>
                    </tr>
                   
                      <tr><td style="width:50%; text-align: right;" ><b>Algorithm:</b></td><td style="width:50%">
                <select name="techniquePredictionSelect" id="techniquePredictionSelect"  style="width: 170px;" >
              <option value="isotonicRegression">Isotonic Regression</option>
                    <option value="linearRegression">Linear Regression</option>
                   
                    <!--option value="gaussianProcesses">Gaussian Processes</option-->
                </select></td>
                    </tr>
                </table>

            </div>
        </div>
        <div class="col-sm-12" style="margin:0 auto; margin:auto; text-align: center;">
            <button  id="attributePredictionButton" name="attributePredictionButton"  type="button"  onclick="processAttributePrediction('1');"><b>Process</b></button>
        </div>
    </div>
</div>
<br>
<br>

            <div id="attributePredictionContent">


            </div>


            
        
<%
} else {
%>

<br>
<br>
<table style="text-align: center; margin:0 auto; margin:auto;">
    <tr>
        <td>


            <div class="col-sm-12">

                Error with the query.
            </div>
        </td>
    </tr>
</table>
<%
    }%>