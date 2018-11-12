<%-- 
    Document   : BehaviorAnalysis
    Created on : Jun 6, 2016, 5:53:30 PM
    Author     : aurea
--%>

<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>
<%
    ArrayList<TimeInterval> listTimeIntervalAttributes = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    if (listTimeIntervalAttributes != null) {
        ArrayList<Integer> selectedAttributesSubset = (ArrayList<Integer>) session.getAttribute("listSelectedAttributesSubset");

        ArrayList<Integer> listIdAttributes = new ArrayList<Integer>();
        ArrayList<String> listNameAttributes = new ArrayList<String>();

        for (int i = 0; i < listTimeIntervalAttributes.size(); i++) {
            String name = listTimeIntervalAttributes.get(i).getNameAttribute() + listTimeIntervalAttributes.get(i).getNameSource() + " "
                    + listTimeIntervalAttributes.get(i).getValueSource() + " / "
                    + listTimeIntervalAttributes.get(i).getInitHour() + " -" + listTimeIntervalAttributes.get(i).getEndHour() + "";

            if (selectedAttributesSubset.contains(i)) {
                listIdAttributes.add(i);
                listNameAttributes.add(name);

            }

        }

%>
<br>
<div class="container-fluid" style="width:500px; height: 120px;   margin:0 auto; margin:auto; text-align: center;">
    <div class="row">

        <div class="col-sm-2">
            <div class="well" style="width:500px; height: 120px;  position:relative; left: 2px;">
                <table>

                    <tr><td style="width:90%; text-align: right;" ><b>Attributes:</b></td><td style="width:50%">

                            <select name="listAttributes" id="listAttributes" multiple="multiple"   >
                                <%for (int i = 0; i < listIdAttributes.size(); i++) {%>
                                <option value="<%=listIdAttributes.get(i)%>" ><%=listNameAttributes.get(i)%></option>
                                <%}
                                %>
                            </select>
                            <script>
                                $("#listAttributes").multipleSelect({
                                    width: 280,
                                    multiple: true,
                                    multipleWidth: 280

                                });
                            </script>
                        </td>
                    </tr>
                    <tr><td style="width:90%; text-align: right;" ><b>Background color:</b></td><td style="width:50%">
                            <select style="width:100%;" name="listBackgroundColor" id="listBackgroundColor"  >
                                <option value="<%="000000"%>" >Black</option>
                                <option value="<%="F0FFFF"%>" >Light Blue</option>
                                <option value="<%="FFF0FF"%>" >Light Red</option>
                                <option value="<%="FFFFF0"%>" >Light Yellow</option>
                                <option value="<%="CE2029"%>" >Red</option>
                                <option value="<%="FFFFFF"%>" >White</option>
                                <option value="<%="FFFF0F"%>" >Yellow</option>
                            </select>

                        </td>
                    </tr>

                </table>

            </div>
        </div>
        <div class="col-sm-12" style="margin:0 auto; margin:auto; text-align: center;">
            <button  id="behaviorAnalysisButton" name="behaviorAnalysisButton"  type="button"  onclick="behaviorAnalysis();"><b>Explore</b></button>
        </div>
    </div>
</div>
<br>
<br>

<div id="behaviorAnalysisContent" style="text-align: center;">


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