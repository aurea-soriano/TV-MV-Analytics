<%-- 
    Document   : CategorizationByScintillationType
    Created on : Mar 1, 2016, 6:32:39 PM
    Author     : aurea
--%>


<%
    String scintillationType = request.getParameter("scintillationType");
    if (scintillationType != null) {

        if (scintillationType.equals("amplitude")) {
%>
<select name="listCategorization" id="listCategorization"   style="width: 120px" onchange="loadDescriptionCategorizationInstanceProjection();" >
     <option value="select">Select...</option>
    <option value="Hegarty2001-S4">Hegarty et al. (2001) - S4</option>
    <option value="Tiwari2011-S4">Tiwari et al. (2011) - S4</option>
    <option value="ITUR2013-S4">ITUR (2013) - S4</option>
</select>
<%} else {
    if (scintillationType.equals("phase")) {
%>
<select name="listCategorization" id="listCategorization"   style="width: 120px" onchange="loadDescriptionCategorizationInstanceProjection();">
    <option value="select">Select...</option>
    <option value="Hegarty2001-Sigma">Hegarty et al. (2001) - &#963;&#966;</option>
    <option value="Tiwari2011-Sigma">Tiwari et al. (2011) - &#963;&#966;</option>
</select>
<%} else {
%><select name="listCategorization" id="listCategorization"   style="width: 120px" onchange="loadDescriptionCategorizationInstanceProjection();">
    <option value="select">Select...</option>
</select>
<%}
    }

} else {
%>
<select name="listCategorization" id="listCategorization"   style="width: 120px" >
    <option value="select">Select...</option>
</select>
<%}%>