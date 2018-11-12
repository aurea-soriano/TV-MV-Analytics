<%-- 
    Document   : DescriptionScintillationCategorization
    Created on : Mar 1, 2016, 6:48:58 PM
    Author     : aurea
--%>
<%@page import="categorization.CategorizationObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="categorization.Tiwari2011Sigma"%>
<%@page import="categorization.Hegarty2001Sigma"%>
<%@page import="categorization.ITUR2013S4"%>
<%@page import="categorization.Tiwari2011S4"%>
<%@page import="categorization.Hegarty2001S4"%>
<%
    String categorization = request.getParameter("categorization");
    ArrayList<CategorizationObject> listCategorizations = (ArrayList<CategorizationObject>) session.getAttribute("listCategorization");
    String description = "";
    
    if (categorization != null && !categorization.equals("select")) {
        
            description=listCategorizations.get(Integer.valueOf(categorization)).getDescription().replace("\\n", "\n");

    }
%>
<textarea rows="5" cols="25" name="descriptionCategorization"  id="descriptionCategorization" disabled style=" color: black;" >
    <%out.print(description);%>
</textarea>