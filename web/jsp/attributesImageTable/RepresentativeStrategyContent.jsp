<%-- 
    Document   : RepresentativeStrategyContent
    Created on : Sep 9, 2017, 10:41:53 PM
    Author     : aurea
--%>

<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.ArrayList"%>
<%
    ArrayList<TimeInterval> listIntervals = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    String representativeStrategy2 = request.getParameter("representativeStrategy");
%>

<% if (representativeStrategy2 != null && representativeStrategy2.equals("medoids")) {%>
<table  style="text-align: center; background-color: white;margin:0 auto; margin:auto;  width:300px;">
    <tr>
        <td style="text-align: right; width:160px; "><b># per cluster:</b></td>
        <td style="width:13px"></td>
        <td >   <select name="numRepresentative" id="numRepresentative"   
                        style="width: 135px" >
                <option value="select">Select...</option>
                <%for (int i = 1; i <= 10; i++) {%>
                <option value="<%=i%>"><%=i%></option>
                <%}%>
            </select></td></tr>
</table>
<%} else {
    if (representativeStrategy2 != null && (representativeStrategy2.equals("linearRegression")||representativeStrategy2.equals("simpleRegression"))) {%>
<table  style="text-align: center; background-color: white;margin:0 auto; margin:auto;  width:300px;">
    <tr>
        <td style="text-align: right; width:160px; "><b>Var. Target:</b></td>
        <td style="width:13px"></td>
        <td >   <select name="varTargetRepresentative" id="varTargetRepresentative"   
                        style="width: 135px" >
                <option value="select" >Select...</option>

                <% for (int aux = 0; aux < listIntervals.size(); aux++) {
                        String name = listIntervals.get(aux).getNameAttribute();
                        String source1 = listIntervals.get(aux).getValueSource();
                        String identifier = name + "-" + source1;
                %>
                <option value="<%=aux%>"><%=identifier%></option>
                <%}

                %>
            </select></td></tr>
   
</table>
<%} else {%>

<table  style="text-align: center; background-color: white;margin:0 auto; margin:auto;  width:300px;">
    <tr>
        <td style="text-align: right; width:160px; "><b></b></td>
        <td style="width:13px"></td>
        <td > </td></tr>
</table>
<%
        }
    }%>
