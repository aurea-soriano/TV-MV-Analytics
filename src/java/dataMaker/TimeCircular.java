/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dataMaker;

import java.awt.Color;
import java.util.ArrayList;
import utils.Operations;

/**
 *
 * @author aurea
 */
public class TimeCircular {

    double[][] correlationMatrix = new double[0][0];
    TimeInterval timeInterval;
    double correlationThreshold = 0.0;
    String timeCircularJSon = "";
    int haarLevel = 0;
    int subGroupSize = 0;
    ArrayList<ArrayList<Double>> listSubGroups = new ArrayList<ArrayList<Double>>();
    ArrayList<ArrayList<BundlePosition>> listSubGroupsBundlePosition = new ArrayList<ArrayList<BundlePosition>>();

    public TimeCircular(TimeInterval timeInterval, Color[] colorScale, double correlationThreshold) {

        this.timeInterval = timeInterval;
        this.correlationThreshold = correlationThreshold;

        calculateCorrelationMatrix();
        createJSonStringCorrelation(colorScale);

    }

    public TimeCircular(TimeInterval timeInterval, Color[] colorScale, double correlationThreshold, int haarLevel) {

        this.timeInterval = timeInterval;
        this.correlationThreshold = correlationThreshold;

        calculateCorrelationMatrix();
        createJSonStringCorrelationAndHaarWavelet(colorScale, haarLevel);

    }

    public TimeCircular(TimeInterval timeInterval, Color[] colorScale, double correlationThreshold, int haarLevel, int subGroupSize) {

        this.timeInterval = timeInterval;
        this.correlationThreshold = correlationThreshold;
        this.haarLevel = haarLevel;
        this.subGroupSize = subGroupSize;

        calculateSubGroups();
        calculateCorrelationMatrixVariantSubGroupSize();
        createJSonCorrelationHaarVariantSubGroupSize(colorScale);

    }

    public TimeCircular(TimeInterval timeInterval, Color[] colorScale) {

        this.timeInterval = timeInterval;

        createJSonStringSimilarity(colorScale);

    }

    public final void calculateSubGroups() {
        int tmpCount = 0;
        int numRows = timeInterval.getMatrix().getRows();
        int numCols = timeInterval.getMatrix().getCols();
        ArrayList<String> listRows = timeInterval.getListLabelsY();
        ArrayList<String> listCols = timeInterval.getListLabelsX();

        ArrayList<Double> tmpSubGroup = new ArrayList<Double>();
        ArrayList<BundlePosition> tmpSubGroupBundlePosition = new ArrayList<BundlePosition>();
        for (int i = 0; i < numRows; i++) {
            for (int j = 0; j < numCols; j++) {
                tmpCount++;
                if (tmpCount < this.subGroupSize) {
                    tmpSubGroup.add(timeInterval.getMatrix().getValue(i, j));
                    tmpSubGroupBundlePosition.add(new BundlePosition(i, j));
                } else {
                    this.listSubGroups.add(tmpSubGroup);
                    this.listSubGroupsBundlePosition.add(tmpSubGroupBundlePosition);
                    tmpSubGroup = new ArrayList<Double>();
                    tmpSubGroupBundlePosition = new ArrayList<BundlePosition>();
                    tmpCount = 0;
                }

            }
        }

    }

    public final void calculateCorrelationMatrixVariantSubGroupSize() {

        correlationMatrix = new double[this.listSubGroups.size()][this.listSubGroups.size()];
        for (int i = 0; i < this.listSubGroups.size(); i++) {
            for (int j = i; j < this.listSubGroups.size(); j++) {
                if (i == j) {
                    correlationMatrix[i][i] = 1;
                } else {
                    double correlation = Operations.pearsonDouble(listSubGroups.get(i), listSubGroups.get(j));
                    correlationMatrix[i][j] = correlation;
                    correlationMatrix[j][i] = correlation;
                }
            }
        }
    }

    public final void calculateCorrelationMatrix() {
        Matrix matrix = timeInterval.getMatrix();
        int numRows = matrix.getRows();
        correlationMatrix = new double[numRows][numRows];

        for (int i = 0; i < numRows; i++) {
            for (int j = i; j < numRows; j++) {
                if (i == j) {
                    correlationMatrix[i][i] = 1;
                } else {
                    double[] vector1 = matrix.getMatrix()[i];
                    double[] vector2 = matrix.getMatrix()[j];
                    double correlation = Operations.pearson(vector1, vector2);
                    correlationMatrix[i][j] = correlation;
                    correlationMatrix[j][i] = correlation;
                }
            }
        }
    }

    public final void createJSonStringSimilarity(Color[] colorScale) {
        timeCircularJSon = "";

        int numRows = timeInterval.getMatrix().getRows();
        int numCols = timeInterval.getMatrix().getCols();

        ArrayList<String> listRows = timeInterval.getListLabelsY();
        ArrayList<String> listCols = timeInterval.getListLabelsX();

        for (int i = 0; i < numRows; i++) {

            for (int j = 0; j < numCols; j++) {
                // {"name":"flare.1.1-1","size":5,"color":"5D8AA8","imports":["flare.1","flare.2","flare.3"]},
                String imports = "";
                int currentValue = (int) Math.round(timeInterval.getMatrix().getValue(i, j));
                double originalValue = utils.Util.round(timeInterval.getMatrix().getOriginalValue(i, j), 2);
                for (int k = 0; k < numRows; k++) {
                    for (int l = 0; l < numCols; l++) {
                        int itValue = (int) Math.round(timeInterval.getMatrix().getValue(k, l));
                        int diff = Math.abs(currentValue - itValue);
                        if (diff <= 1) {
                            imports += "'" + listRows.get(k).replace(".", "_") + "." + listCols.get(l).replace(".", "_") + "',";
                        }
                    }
                }
                imports = imports.substring(0, imports.length() - 1);
                imports = "[" + imports + "]";

                String pointText = "{";
                pointText += "'name': '" + listRows.get(i).replace(".", "_") + "." + listCols.get(j).replace(".", "_") + "',";
                pointText += "'size': 5,";

                Color colorCell = Color.gray;
                if (currentValue >= 0 && currentValue < 256) {
                    colorCell = colorScale[255 - currentValue];
                }
                String hexColor = Integer.toHexString(colorCell.getRGB() & 0xffffff);
                while (hexColor.length() < 6) {
                    hexColor = "0" + hexColor;
                }
                pointText += "'color': '" + hexColor + "',";
                pointText += "'origvalue': '" + originalValue + "',";
                pointText += "'imports': " + imports + "";
                pointText += "},";
                timeCircularJSon += pointText;

            }
        }
        if ((timeCircularJSon.length() > 0) && (timeCircularJSon.lastIndexOf(",") == (timeCircularJSon.length() - 1))) {
            timeCircularJSon = timeCircularJSon.substring(0, timeCircularJSon.length() - 1);
        }
        timeCircularJSon = "[" + timeCircularJSon + "]";
    }

    public final void createJSonStringCorrelation(Color[] colorScale) {
        timeCircularJSon = "";

        int numRows = timeInterval.getMatrix().getRows();
        int numCols = timeInterval.getMatrix().getCols();

        ArrayList<String> listRows = timeInterval.getListLabelsY();
        ArrayList<String> listCols = timeInterval.getListLabelsX();

        for (int i = 0; i < numRows; i++) {
            String imports = "";
            for (int k = 0; k < numRows; k++) {
                if (correlationMatrix[i][k] >= correlationThreshold) {
                    imports += "'" + listRows.get(k).replace(".", "_") + "',";
                }
            }
            imports = imports.substring(0, imports.length() - 1);
            imports = "[" + imports + "]";
            for (int j = 0; j < numCols; j++) {
                // {"name":"flare.1.1-1","size":5,"color":"5D8AA8","imports":["flare.1","flare.2","flare.3"]},
                String pointText = "{";
                pointText += "'name': '" + listRows.get(i).replace(".", "_") + "." + listCols.get(j).replace(".", "_") + "',";
                pointText += "'size': 5,";

                int colorPosition = (int) Math.round(timeInterval.getMatrix().getValue(i, j));
                double originalValue = utils.Util.round(timeInterval.getMatrix().getOriginalValue(i, j), 2);
                Color colorCell = Color.gray;
                if (colorPosition >= 0 && colorPosition < 256) {
                    colorCell = colorScale[255 - colorPosition];
                }
                String hexColor = Integer.toHexString(colorCell.getRGB() & 0xffffff);
                while (hexColor.length() < 6) {
                    hexColor = "0" + hexColor;
                }
                pointText += "'color': '" + hexColor + "',";
                pointText += "'origvalue': '" + originalValue + "',";
                pointText += "'imports': " + imports + "";
                pointText += "},";
                timeCircularJSon += pointText;

            }
        }
        if ((timeCircularJSon.length() > 0) && (timeCircularJSon.lastIndexOf(",") == (timeCircularJSon.length() - 1))) {
            timeCircularJSon = timeCircularJSon.substring(0, timeCircularJSon.length() - 1);
        }
        timeCircularJSon = "[" + timeCircularJSon + "]";
    }

    public final void createJSonCorrelationHaarVariantSubGroupSize(Color[] colorScale) {
        timeCircularJSon = "";

        int step = (int) Math.pow(2, haarLevel);
        ArrayList<String> listRows = timeInterval.getListLabelsY();
        ArrayList<String> listCols = timeInterval.getListLabelsX();
        for (int i = 0; i < this.listSubGroups.size(); i++) {
            int countCorrNumber = 0;
            String imports = "";
            for (int k = 0; k < this.listSubGroups.size(); k++) {
                
                if ((correlationMatrix[i][k] >= correlationThreshold)  && (i != k)) {
                    imports += "'" + k + "',";
                    countCorrNumber++;
                }
            }
            if (imports.length() > 0) {
                imports = imports.substring(0, imports.length() - 1);
            }
            imports = "[" + imports + "]";
            if (haarLevel == 0) {
                for (int j = 0; j < this.listSubGroups.get(i).size(); j++) {
                    // {"name":"flare.1.1-1","size":5,"color":"5D8AA8","imports":["flare.1","flare.2","flare.3"]},
                    int positionRow = listSubGroupsBundlePosition.get(i).get(j).getRow();
                    int positionCol = listSubGroupsBundlePosition.get(i).get(j).getCol();
                    String pointText = "{";
                    if (countCorrNumber > 0) {
                        pointText += "'name': '" + i + "." + listRows.get(positionRow).replace(".", "_")
                                + "-" + listCols.get(positionCol).replace(".", "_") + "',";
                    } else {

                        pointText += "'name': '" + listRows.get(positionRow).replace(".", "_")
                                + "-" + listCols.get(positionCol).replace(".", "_") + "',";
                    }
                    pointText += "'size': 5,";

                    int colorPosition = (int) Math.round(timeInterval.getMatrix().getValue(positionRow, positionCol));
                    double originalValue = utils.Util.round(timeInterval.getMatrix().getOriginalValue(positionRow, positionCol), 2);
                    Color colorCell = Color.gray;
                    if (colorPosition >= 0 && colorPosition < 256) {
                        colorCell = colorScale[255 - colorPosition];
                    }
                    String hexColor = Integer.toHexString(colorCell.getRGB() & 0xffffff);
                    while (hexColor.length() < 6) {
                        hexColor = "0" + hexColor;
                    }
                    pointText += "'color': '" + hexColor + "',";
                    pointText += "'origvalue': '" + originalValue + "',";
                    pointText += "'imports': " + imports + "";
                    pointText += "},";
                    timeCircularJSon += pointText;

                }
            } else {

                for (int j = 0; j < this.listSubGroups.get(i).size(); j=j+step) {
                    // {"name":"flare.1.1-1","size":5,"color":"5D8AA8","imports":["flare.1","flare.2","flare.3"]},
                    int positionRow = listSubGroupsBundlePosition.get(i).get(j).getRow();
                    int positionCol = listSubGroupsBundlePosition.get(i).get(j).getCol();
                    String pointText = "{";
                    if (countCorrNumber > 0) {
                        pointText += "'name': '" + i + "." + listRows.get(positionRow).replace(".", "_")
                                + "-" + listCols.get(positionCol).replace(".", "_") + "',";
                    } else {

                        pointText += "'name': '" + listRows.get(positionRow).replace(".", "_")
                                + "-" + listCols.get(positionCol).replace(".", "_") + "',";
                    }
                    pointText += "'size': 5,";

                    double value = 0.0;
                    double originalValue = 0.0;

                    int stepCount = 0;
                    for (int st = 0; st < step && (j + st) < this.listSubGroups.get(i).size(); st++) {
                        int positionTmpRow = listSubGroupsBundlePosition.get(i).get(j + st).getRow();
                        int positionTmpCol = listSubGroupsBundlePosition.get(i).get(j + st).getCol();

                        value += timeInterval.getMatrix().getValue(positionTmpRow, positionTmpCol);

                        originalValue += utils.Util.round(timeInterval.getMatrix().getOriginalValue(positionTmpRow, positionTmpCol), 2);
                        stepCount++;
                    }

                    value /= stepCount;
                    originalValue = utils.Util.round(originalValue / stepCount, 2);
                    int colorPosition = (int) Math.round(value);
                    Color colorCell = Color.gray;
                    if (colorPosition >= 0 && colorPosition < 256) {
                        colorCell = colorScale[255 - colorPosition];
                    }
                    String hexColor = Integer.toHexString(colorCell.getRGB() & 0xffffff);
                    while (hexColor.length() < 6) {
                        hexColor = "0" + hexColor;
                    }
                    pointText += "'color': '" + hexColor + "',";
                    pointText += "'origvalue': '" + originalValue + "',";
                    pointText += "'imports': " + imports + "";
                    pointText += "},";
                    timeCircularJSon += pointText;

                }
            }
        }
        if ((timeCircularJSon.length() > 0) && (timeCircularJSon.lastIndexOf(",") == (timeCircularJSon.length() - 1))) {
            timeCircularJSon = timeCircularJSon.substring(0, timeCircularJSon.length() - 1);
        }
        timeCircularJSon = "[" + timeCircularJSon + "]";
    }

    public final void createJSonStringCorrelationAndHaarWavelet(Color[] colorScale, int haarLevel) {
        timeCircularJSon = "";

        int numRows = timeInterval.getMatrix().getRows();
        int numCols = timeInterval.getMatrix().getCols();

        ArrayList<String> listRows = timeInterval.getListLabelsY();
        ArrayList<String> listCols = timeInterval.getListLabelsX();
        int step = (int) Math.pow(2, haarLevel);
        for (int i = 0; i < numRows; i++) {
            String imports = "";
            for (int k = 0; k < numRows; k++) {
                if (correlationMatrix[i][k] >= correlationThreshold) {
                    imports += "'" + listRows.get(k).replace(".", "_") + "',";
                }
            }
            imports = imports.substring(0, imports.length() - 1);
            imports = "[" + imports + "]";
            if (haarLevel == 0) {
                for (int j = 0; j < numCols; j++) {
                    // {"name":"flare.1.1-1","size":5,"color":"5D8AA8","imports":["flare.1","flare.2","flare.3"]},
                    String pointText = "{";
                    pointText += "'name': '" + listRows.get(i).replace(".", "_") + "." + listCols.get(j).replace(".", "_") + "',";
                    pointText += "'size': 5,";

                    int colorPosition = (int) Math.round(timeInterval.getMatrix().getValue(i, j));
                    double originalValue = utils.Util.round(timeInterval.getMatrix().getOriginalValue(i, j), 2);
                    Color colorCell = Color.gray;
                    if (colorPosition >= 0 && colorPosition < 256) {
                        colorCell = colorScale[255 - colorPosition];
                    }
                    String hexColor = Integer.toHexString(colorCell.getRGB() & 0xffffff);
                    while (hexColor.length() < 6) {
                        hexColor = "0" + hexColor;
                    }
                    pointText += "'color': '" + hexColor + "',";
                    pointText += "'origvalue': '" + originalValue + "',";
                    pointText += "'imports': " + imports + "";
                    pointText += "},";
                    timeCircularJSon += pointText;

                }
            } else {

                for (int j = 0; j < numCols; j = j + step) {
                    // {"name":"flare.1.1-1","size":5,"color":"5D8AA8","imports":["flare.1","flare.2","flare.3"]},
                    String pointText = "{";
                    pointText += "'name': '" + listRows.get(i).replace(".", "_") + "." + listCols.get(j).replace(".", "_") + "',";
                    pointText += "'size': 5,";

                    double value = 0.0;
                    double originalValue = 0.0;

                    int stepCount = 0;
                    for (int st = 0; st < step && (j + st) < numCols; st++) {
                        value += timeInterval.getMatrix().getValue(i, j + st);
                        originalValue += utils.Util.round(timeInterval.getMatrix().getOriginalValue(i, j + st), 2);
                        stepCount++;
                    }

                    value /= stepCount;
                    originalValue = utils.Util.round(originalValue / stepCount, 2);
                    int colorPosition = (int) Math.round(value);
                    Color colorCell = Color.gray;
                    if (colorPosition >= 0 && colorPosition < 256) {
                        colorCell = colorScale[255 - colorPosition];
                    }
                    String hexColor = Integer.toHexString(colorCell.getRGB() & 0xffffff);
                    while (hexColor.length() < 6) {
                        hexColor = "0" + hexColor;
                    }
                    pointText += "'color': '" + hexColor + "',";
                    pointText += "'origvalue': '" + originalValue + "',";
                    pointText += "'imports': " + imports + "";
                    pointText += "},";
                    timeCircularJSon += pointText;

                }
            }
        }
        if ((timeCircularJSon.length() > 0) && (timeCircularJSon.lastIndexOf(",") == (timeCircularJSon.length() - 1))) {
            timeCircularJSon = timeCircularJSon.substring(0, timeCircularJSon.length() - 1);
        }
        timeCircularJSon = "[" + timeCircularJSon + "]";
    }

    public String getTimeCircularJSon() {
        return timeCircularJSon;
    }

}
