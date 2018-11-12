<%-- 
    Document   : SelectedAttributesSubset
    Created on : Feb 25, 2016, 7:38:51 PM
    Author     : aurea
--%>

<%@page import="dataMaker.TimeInterval"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    ArrayList<Integer> selectedAttributesSubset = (ArrayList<Integer>) session.getAttribute("listSelectedAttributesSubset");

    ArrayList<TimeInterval> listTimeIntervalsData2 = (ArrayList<TimeInterval>) session.getAttribute("listTimeIntervalsData");
    ArrayList<String> listNamesAttributes = new ArrayList<String>();
    for (int i = 0; i < selectedAttributesSubset.size(); i++) {
        String name = listTimeIntervalsData2.get(selectedAttributesSubset.get(i)).getNameAttribute();
        String source1 = listTimeIntervalsData2.get(selectedAttributesSubset.get(i)).getValueSource();
        String identifier = name + "-" + source1;
        if (!listNamesAttributes.contains(identifier)) {
            listNamesAttributes.add(identifier);
        }
    }
    String identifierNameStr = request.getParameter("attributeName");
    if (identifierNameStr != null) {
        for (int i = 0; i < selectedAttributesSubset.size(); i++) {
            String name = listTimeIntervalsData2.get(selectedAttributesSubset.get(i)).getNameAttribute();
            String source1 = listTimeIntervalsData2.get(selectedAttributesSubset.get(i)).getValueSource();
            String identifier = name + "-" + source1;
            if (identifierNameStr.equals(identifier)) {
                selectedAttributesSubset.remove(i);

            }
        }

        if (listNamesAttributes.contains(identifierNameStr)) {
            int index = listNamesAttributes.indexOf(identifierNameStr);
            listNamesAttributes.remove(index);
        }
    }

    String idAttributeStr = request.getParameter("idAttribute");
    if (idAttributeStr != null) {
        Integer idAttribute = Integer.valueOf(request.getParameter("idAttribute"));
        if (!selectedAttributesSubset.contains(idAttribute)) {
            selectedAttributesSubset.add(idAttribute);
        } else {
            int index = selectedAttributesSubset.indexOf(idAttribute);
            selectedAttributesSubset.remove(idAttribute);
        }
        listNamesAttributes = new ArrayList<String>();
        for (int i = 0; i < selectedAttributesSubset.size(); i++) {
            String name = listTimeIntervalsData2.get(selectedAttributesSubset.get(i)).getNameAttribute();
            String source1 = listTimeIntervalsData2.get(selectedAttributesSubset.get(i)).getValueSource();
            String identifier = name + "-" + source1;
            if (!listNamesAttributes.contains(identifier)) {
                listNamesAttributes.add(identifier);
            }
        }

        session.setAttribute("listSelectedAttributesSubset", selectedAttributesSubset);
    }
%><table>
    <tr>
        <td style="width:20px">

        </td>
        <td>
            <div id="titleAttributes"><b>Selected variables:</b></div>

            <br>
            <select style="height: 300px;width:200px" id="selectSubsetAttributesSelected"   name="selectSubsetAttributesSelected" multiple>
                <%   for (int i = 0; i < listNamesAttributes.size(); i++) {
               %>
                <option value="<%=listNamesAttributes.get(i)%>" ondblclick="addRemoveAttributeSubsetSelectionFromList('<%=listNamesAttributes.get(i)%>');"><%=(listNamesAttributes.get(i))%></option>
                <%}%>
            </select>
        </td>
    </tr>

</table>