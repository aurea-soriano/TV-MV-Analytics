<%-- 
    Document   : InstanceNonHierarchicalProjectionMapAjax
    Created on : Aug 10, 2016, 4:10:16 PM
    Author     : aurea
--%>
<%@page import="utils.Operations"%>
<%@page import="java.util.Collections"%>
<%@page import="color.HeatedObject"%>
<%@page import="java.awt.Color"%>
<%@page import="java.util.ArrayList"%>
<%@page import="matrix.pointsmatrix.AbstractMatrix"%>
<%
    String maxValueFilterStr = request.getParameter("maxValueFilter");
    String minValueFilterStr = request.getParameter("minValueFilter");

    Float maxValueFilter = Float.valueOf(maxValueFilterStr);
    Float minValueFilter = Float.valueOf(minValueFilterStr);

    AbstractMatrix projectedMatrixNHP = (AbstractMatrix) session.getAttribute("projectedMatrixNHP");
    ArrayList<Float> listKlassesNHP = (ArrayList<Float>) session.getAttribute("listKlassesNHP");
    ArrayList<Float> listLabelsNHP = (ArrayList<Float>) session.getAttribute("listLabelsNHP");
    ArrayList<String> listDatesNHP = (ArrayList<String>) session.getAttribute("listDatesNHP");
    String colorStrategyNHP = (String) session.getAttribute("colorStrategyNHP");
    float maxXNHP = (float) session.getAttribute("maxXNHP");
    float minXNHP = (float) session.getAttribute("minXNHP");
    float maxYNHP = (float) session.getAttribute("maxYNHP");
    float minYNHP = (float) session.getAttribute("minYNHP");

    String color4 = "f0f8ff";
    String color3 = "087830";
    String color2 = "ffbf00";
    String color1 = "a40000";

    Color[] colorKlasses = (new HeatedObject()).getColorScale();

    float maxValueKlass = Collections.max(listKlassesNHP);
    float minValueKlass = Collections.min(listKlassesNHP);
    String datasetProjection = "[";
    if (projectedMatrixNHP != null) {

        for (int i = 0; i < projectedMatrixNHP.getRowCount(); i++) {

            if (projectedMatrixNHP.getRow(i).getKlass() >= minValueFilter
                    && projectedMatrixNHP.getRow(i).getKlass() <= maxValueFilter) {
                int valueX = Math.round(Operations.minmax(projectedMatrixNHP.getRow(i).getValue(0), minXNHP, maxXNHP, 20.f, 1070.f));
                int valueY = Math.round(Operations.minmax(projectedMatrixNHP.getRow(i).getValue(1), minYNHP, maxYNHP, 20.f, 740.f));

                String colorBackground = "";
                if (colorStrategyNHP.equals("categorized")) {
                    if (projectedMatrixNHP.getRow(i).getKlass() == 4.0) {
                        colorBackground = color4;
                    } else {
                        if (projectedMatrixNHP.getRow(i).getKlass() == 3.0) {
                            colorBackground = color3;
                        } else {
                            if (projectedMatrixNHP.getRow(i).getKlass() == 2.0) {
                                colorBackground = color2;
                            } else {
                                if (projectedMatrixNHP.getRow(i).getKlass() == 1.0) {
                                    colorBackground = color1;
                                }
                            }
                        }
                    }
                } else {
                    int indexColor = (int) Math.abs(Operations.minmax(listKlassesNHP.get(i), minValueKlass, maxValueKlass, 0.f, 255.f));
                    indexColor = 255 - indexColor;
                    colorBackground = Integer.toHexString(colorKlasses[indexColor].getRGB()).substring(2);
                }

                datasetProjection += "{\'x\':" + valueX + ", \'y\':" + valueY + ", \'color\': \'" + colorBackground
                        + "\', \'name\': \'" + listLabelsNHP.get(i) +"\', \'date\': \'"+listDatesNHP.get(i)+ "\'},";

            }

        }
        if (datasetProjection.endsWith(",")) {
            datasetProjection = datasetProjection.substring(0, datasetProjection.length() - 1);
        }
    }
    datasetProjection += "]";
%>
<div id="instanceProjectionMapContentAjax">
    <script type="text/javascript"> createInstanceProjection("instanceProjectionMapContentAjax", "1010", "760", "<%=datasetProjection%>");</script> 
</div>