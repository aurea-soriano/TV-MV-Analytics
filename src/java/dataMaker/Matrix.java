/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dataMaker;

import color.PseudoRainbow;
import java.awt.Color;
import java.awt.image.BufferedImage;
import utils.Operations;

/**
 *
 * @author aurea
 */
public class Matrix implements Cloneable {

    private double[][] originalMatrix = null;
    private double[][] matrix = null;
    private boolean[][] flags = null;
    private int rows = 0;
    private int cols = 0;
    private int[] initPositions = null;
    private int[] interpolatedInitPositions = null;
    double maxValue = Double.NEGATIVE_INFINITY;
    double minValue = Double.POSITIVE_INFINITY;
    int originalLackNumber = 0;
    int interpolatedLackNumber = 0;

    public double[][] getMatrix() {
        return matrix;
    }

    public double[][] getOriginalMatrix() {
        return originalMatrix;
    }

    public void setValue(int row, int col, double value) {
        this.matrix[row][col] = value;
    }

    public double getValue(int row, int col) {
        return this.matrix[row][col];
    }

    public void setOriginalValue(int row, int col, double value) {
        this.originalMatrix[row][col] = value;
    }

    public double getOriginalValue(int row, int col) {
        return this.originalMatrix[row][col];
    }

    public boolean getFlag(int row, int col) {
        return this.flags[row][col];
    }

    public int getCols() {
        return cols;
    }

    public int getRows() {
        return rows;
    }

    public double getMaxValue() {
        return maxValue;
    }

    public double getMinValue() {
        return minValue;
    }

    public Matrix() {
        matrix = new double[0][0];
        originalMatrix = new double[0][0];
        flags = new boolean[0][0];
    }

    public Matrix(int rowsSize, int colSize) {
        rows = rowsSize;
        cols = colSize;
        matrix = new double[rowsSize][colSize];
        originalMatrix = new double[rowsSize][colSize];
        flags = new boolean[rowsSize][colSize];

        fillInitial();
    }

    public Matrix(Matrix m) {
        matrix = new double[m.getRows()][m.getCols()];
        originalMatrix = new double[m.getRows()][m.getCols()];
        flags = new boolean[m.getRows()][m.getCols()];
        for (int i = 0; i < m.getRows(); i++) {
            for (int j = 0; j < m.getCols(); j++) {
                matrix[i][j] = m.getValue(i, j);
                originalMatrix[i][j] = m.getValue(i, j);
                flags[i][j] = m.getFlag(i, j);

            }

        }

    }

    public void fillInitial() {

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                this.matrix[i][j] = Double.NEGATIVE_INFINITY;
                this.flags[i][j] = false;
            }
        }
    }

    public void print() {

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                System.out.print((int) this.matrix[i][j] + " ");
            }
            System.out.println();
        }
    }

    public boolean isEmpty() {
        boolean flag = true;
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (this.matrix[i][j] != Double.NEGATIVE_INFINITY) {
                    flag = false;
                }
            }

        }
        return flag;
    }

    public int countOriginalLacks() {
        return originalLackNumber;
    }

    public int countInterpolatedLacks() {
        return interpolatedLackNumber;
    }

    public void normalize() {
        int originalLackNumberVar = 0;
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (matrix[i][j] != Double.NEGATIVE_INFINITY) {
                    originalMatrix[i][j] = matrix[i][j];
                } else {
                    originalMatrix[i][j] = Double.NaN;
                    originalLackNumberVar++;
                }
            }
        }
        this.originalLackNumber = originalLackNumberVar;
        maxValue = Double.NEGATIVE_INFINITY;
        minValue = Double.POSITIVE_INFINITY;

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (matrix[i][j] != Double.NEGATIVE_INFINITY) {
                    if (maxValue < matrix[i][j]) {
                        maxValue = matrix[i][j];
                    }
                    if (minValue > matrix[i][j]) {
                        minValue = matrix[i][j];
                    }
                }
            }

        }

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (matrix[i][j] != Double.NEGATIVE_INFINITY) {
                    double value = Operations.minmax(matrix[i][j], minValue, maxValue, 0.0, 255.0);
                    this.matrix[i][j] = value;
                    this.flags[i][j] = false;
                }
            }

        }
    }

    // Linear interpolation (A-B)*xi +B
    public void linearColInterpolation() {

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (matrix[i][j] == Double.NEGATIVE_INFINITY) {

                    if ((j - 1) >= 0 && (j + 1) < cols) {
                        int index1 = j - 1;
                        int count1 = 1;
                        double value1 = matrix[i][index1];
                        int index2 = j + 1;
                        int count2 = 1;
                        double value2 = matrix[i][index2];
                        index1--;
                        while (value1 == Double.NEGATIVE_INFINITY && index1 >= 0 && count1 <= 2) {

                            value1 = matrix[i][index1];
                            index1--;
                            count1++;
                        }
                        index2++;
                        while (value2 == Double.NEGATIVE_INFINITY && index2 < cols && count2 <= 2) {

                            value2 = matrix[i][index2];
                            index2++;
                            count2++;
                        }

                        if (value1 != Double.NEGATIVE_INFINITY && value2 != Double.NEGATIVE_INFINITY) {
                            double sum = count1 + count2;
                            if (sum == 0.0) {
                                sum = 0.01;
                            }
                            double xi = 1 / sum;
                            double mean = (value1 - value2) * xi + value2;

                            matrix[i][j] = mean;
                            flags[i][j] = true;
                        }

                    }

                }
            }

        }

    }

    // Linear interpolation (A-B)*xi +B
    public void linearRowInterpolation() {

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {

                if (matrix[i][j] == Double.NEGATIVE_INFINITY) {
                    if ((i - 1) >= 0 && (i + 1) < rows) {
                        int index1 = i - 1;
                        int count1 = 1;
                        double value1 = matrix[index1][j];
                        int index2 = i + 1;
                        int count2 = 1;
                        double value2 = matrix[index2][j];
                        index1--;
                        while (value1 == Double.NEGATIVE_INFINITY && index1 >= 0 && count1 <= 6) {

                            value1 = matrix[index1][j];
                            index1--;
                            count1++;
                        }
                        index2++;
                        while (value2 == Double.NEGATIVE_INFINITY && index2 < rows && count2 <= 6) {

                            value2 = matrix[index2][j];
                            index2++;
                            count2++;
                        }

                        if (value1 != Double.NEGATIVE_INFINITY && value2 != Double.NEGATIVE_INFINITY) {
                            double sum = count1 + count2;
                            if (sum == 0.0) {
                                sum = 0.01;
                            }
                            double xi = 1 / sum;
                            double mean = (value1 - value2) * xi + value2;

                            matrix[i][j] = mean;
                            flags[i][j] = true;
                        }

                        // V[i][j] = mean;
                    }

                    if (matrix[i][j] == Double.NEGATIVE_INFINITY) {

                        if ((j - 1) >= 0 && (j + 1) < cols) {
                            int index1 = j - 1;
                            int count1 = 1;
                            double value1 = matrix[i][index1];
                            int index2 = j + 1;
                            int count2 = 1;
                            double value2 = matrix[i][index2];
                            index1--;
                            while (value1 == Double.NEGATIVE_INFINITY && index1 >= 0 && count1 <= 2) {

                                value1 = matrix[i][index1];
                                index1--;
                                count1++;
                            }
                            index2++;
                            while (value2 == Double.NEGATIVE_INFINITY && index2 < cols && count2 <= 2) {

                                value2 = matrix[i][index2];
                                index2++;
                                count2++;
                            }

                            if (value1 != Double.NEGATIVE_INFINITY && value2 != Double.NEGATIVE_INFINITY) {
                                double sum = count1 + count2;
                                if (sum == 0.0) {
                                    sum = 0.01;
                                }
                                double xi = 1 / sum;
                                double mean = (value1 - value2) * xi + value2;

                                matrix[i][j] = mean;
                                flags[i][j] = true;
                            }

                        }
                    }/* else {
                     if ((i - 1) >= 0 && (i + 1) >= rows && V[i - 1][j] != Double.NEGATIVE_INFINITY) {
                     V[i][j] = V[i - 1][j];
                     flags[i][j] = true;
                     } else {
                     if ((i - 1) < 0 && (i + 1) < rows && V[i + 1][j] != Double.NEGATIVE_INFINITY) {
                     V[i][j] = V[i + 1][j];
                     flags[i][j] = true;
                     }
                     }
                     }*/

                }

            }

        }

    }

    // Linear interpolation (A-B)*xi +B
    public void rowAndColLinearInterpolation() {

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (matrix[i][j] == Double.NEGATIVE_INFINITY) {

                    if ((j - 1) >= 0 && (j + 1) < cols) {
                        int index1 = j - 1;
                        int count1 = 1;
                        double previousValue = matrix[i][index1];
                        int index2 = j + 1;
                        int count2 = 1;
                        double posteriorValue = matrix[i][index2];
                        index1--;
                        while (previousValue == Double.NEGATIVE_INFINITY && index1 >= 0) {//&& count1 <= 6

                            previousValue = matrix[i][index1];
                            index1--;
                            count1++;
                        }
                        index2++;
                        while (posteriorValue == Double.NEGATIVE_INFINITY && index2 < cols) {//&& count2 <= 6

                            posteriorValue = matrix[i][index2];
                            index2++;
                            count2++;
                        }

                        if (previousValue != Double.NEGATIVE_INFINITY && posteriorValue != Double.NEGATIVE_INFINITY) {
                            double sum = count1 + count2;

                            double xi = 1 / sum;
                            double mean = (previousValue - posteriorValue) * xi + posteriorValue;

                            matrix[i][j] = mean;
                            flags[i][j] = true;
                        }

                    }

                    if (matrix[i][j] == Double.NEGATIVE_INFINITY) {
                        if ((i - 1) >= 0 && (i + 1) < rows) {
                            int index1 = i - 1;
                            int count1 = 1;
                            double previousValue = matrix[index1][j];
                            int index2 = i + 1;
                            int count2 = 1;
                            double posteriorValue = matrix[index2][j];
                            index1--;
                            while (previousValue == Double.NEGATIVE_INFINITY && index1 >= 0) {//&& count1 <= 6

                                previousValue = matrix[index1][j];
                                index1--;
                                count1++;
                            }
                            index2++;
                            while (posteriorValue == Double.NEGATIVE_INFINITY && index2 < rows) {//&& count2 <= 6

                                posteriorValue = matrix[index2][j];
                                index2++;
                                count2++;
                            }

                            if (previousValue != Double.NEGATIVE_INFINITY && posteriorValue != Double.NEGATIVE_INFINITY) {
                                double sum = count1 + count2;

                                double xi = 1 / sum;
                                double mean = (previousValue - posteriorValue) * xi + posteriorValue;

                                matrix[i][j] = mean;
                                flags[i][j] = true;
                            }

                        }

                    }

                }
            }

        }

    }

    // Linear interpolation (A-B)*xi +B
    public void rowInterpolation() {

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (matrix[i][j] == Double.NEGATIVE_INFINITY) {

                    if (matrix[i][j] == Double.NEGATIVE_INFINITY) {
                        if ((i - 1) >= 0 && (i + 1) < rows) {
                            int index1 = i - 1;
                            int count1 = 1;
                            double previousValue = matrix[index1][j];
                            int index2 = i + 1;
                            int count2 = 1;
                            double posteriorValue = matrix[index2][j];
                            index1--;
                            while (previousValue == Double.NEGATIVE_INFINITY && index1 >= 0) {//&& count1 <= 6

                                previousValue = matrix[index1][j];
                                index1--;
                                count1++;
                            }
                            index2++;
                            while (posteriorValue == Double.NEGATIVE_INFINITY && index2 < rows) {//&& count2 <= 6

                                posteriorValue = matrix[index2][j];
                                index2++;
                                count2++;
                            }

                            if (previousValue != Double.NEGATIVE_INFINITY && posteriorValue != Double.NEGATIVE_INFINITY) {
                                double sum = count1 + count2;

                                double xi = 1 / sum;
                                double mean = (previousValue - posteriorValue) * xi + posteriorValue;

                                matrix[i][j] = mean;
                                flags[i][j] = true;
                            }

                        }

                    }

                }
            }

        }

    }

    public void linearMultipleRowsInterpolation() {

        for (int j = 0; j < cols; j++) {
            int lastNoNull = -1;
            int nextNoNull = -1;
            for (int i = 0; i < rows; i++) {
                if (matrix[i][j] == Double.NEGATIVE_INFINITY) {

                    // System.out.println("interpolar "+i+" - "+j);
                    if (lastNoNull == -1) {
                        int lastNoNullTmp = i - 1;
                        while (lastNoNullTmp >= 0 && matrix[lastNoNullTmp][j] == Double.NEGATIVE_INFINITY) {
                            lastNoNullTmp--;
                        }
                        lastNoNull = lastNoNullTmp;

                    }
                    //System.out.println("lastNoNull "+lastNoNull);
                    if (nextNoNull == -1) {
                        int nextNoNullTmp = i + 1;
                        while (nextNoNullTmp < rows && matrix[nextNoNullTmp][j] == Double.NEGATIVE_INFINITY) {
                            nextNoNullTmp++;
                        }
                        nextNoNull = nextNoNullTmp;

                    }
                    //  System.out.println("nextNoNull "+nextNoNull);
                    if (lastNoNull >= 0 && lastNoNull < rows && nextNoNull >= 0 && nextNoNull < rows && lastNoNull < i
                            && i < nextNoNull) {
                        double sum = Math.abs(i - lastNoNull) + Math.abs(nextNoNull - i);
                        if (sum == 0.0) {
                            sum = 0.01;
                        }
                        double xi = 1 / sum;
                        double mean = (matrix[lastNoNull][j] - matrix[nextNoNull][j]) * xi + matrix[nextNoNull][j];
                        lastNoNull = i;
                        matrix[i][j] = mean;
                        flags[i][j] = true;
                        // System.out.println("mean "+mean);
                    }

                } else {
                    lastNoNull = i;
                }
            }

        }
    }

    public void calculateInitialPositions() {
        initPositions = new int[this.rows];
        interpolatedInitPositions = new int[this.rows];
        for (int i = 0; i < rows; i++) {
            int initialPosition = -1;
            for (int j = 0; j < cols; j++) {
                if (matrix[i][j] != Double.NEGATIVE_INFINITY) {
                    initialPosition = j;
                    break;
                }
            }
            initPositions[i] = initialPosition;
        }

        int lastNoNull = -1;
        for (int i = 0; i < rows; i++) {

            if (initPositions[i] != -1) {
                lastNoNull = i;
                interpolatedInitPositions[i] = initPositions[i];
            } else {
                int nextNoNull = -1;
                for (int j = i + 1; j < rows; j++) {
                    if (initPositions[j] != -1) {
                        nextNoNull = j;
                        break;
                    }
                }
                if (lastNoNull != -1 && nextNoNull != -1) {
                    double sum = (initPositions[lastNoNull] + initPositions[nextNoNull]);
                    if (initPositions[lastNoNull] == initPositions[nextNoNull]) {
                        interpolatedInitPositions[i] = initPositions[lastNoNull];
                    } else {
                        double xi = 1 / (sum);
                        interpolatedInitPositions[i] = (int) Math.floor((initPositions[nextNoNull] - initPositions[lastNoNull]) * xi + initPositions[lastNoNull]);
                    }
                } else {
                    if (lastNoNull != -1) {
                        interpolatedInitPositions[i] = initPositions[lastNoNull];
                    } else {
                        interpolatedInitPositions[i] = initPositions[nextNoNull];

                    }
                }
            }

        }

    }

    public void entireRowInterpolationBefore() {
        int lastNoNull = -1;
        for (int i = 0; i < interpolatedInitPositions.length; i++) {

            if (initPositions[i] == -1) {
                int nextNoNull = -1;
                for (int j = i + 1; j < rows; j++) {
                    if (initPositions[j] != -1) {
                        nextNoNull = j;
                        break;
                    }
                }
                if (lastNoNull != -1 && nextNoNull != -1) {

                    for (int itemX = interpolatedInitPositions[lastNoNull],
                            itemY = interpolatedInitPositions[nextNoNull],
                            itemZ = interpolatedInitPositions[i];
                            itemX < cols && itemY < cols && itemZ < cols;
                            itemX++, itemY++, itemZ++) {
                        if (matrix[lastNoNull][itemX] != Double.NEGATIVE_INFINITY && matrix[nextNoNull][itemY] != Double.NEGATIVE_INFINITY) {
                            double xi = 1 / (matrix[lastNoNull][itemX] + matrix[nextNoNull][itemY]);
                            matrix[i][itemZ] = (matrix[nextNoNull][itemY] - matrix[lastNoNull][itemX]) * xi + matrix[lastNoNull][itemX];
                            flags[i][itemZ] = true;
                        } else {
                            matrix[i][itemZ] = Double.NEGATIVE_INFINITY;
                        }

                    }
                } else {
                    if (lastNoNull != -1) {
                        for (int itemX = interpolatedInitPositions[lastNoNull],
                                itemZ = interpolatedInitPositions[i];
                                itemX < cols && itemZ < cols;
                                itemX++, itemZ++) {

                            matrix[i][itemZ] = matrix[lastNoNull][itemX];
                            if (matrix[lastNoNull][itemX] != Double.NEGATIVE_INFINITY) {
                                flags[i][itemZ] = true;
                            }
                        }
                    } else {
                        if (nextNoNull != -1) {
                            for (int itemY = interpolatedInitPositions[nextNoNull],
                                    itemZ = interpolatedInitPositions[i];
                                    itemY < cols && itemZ < cols;
                                    itemY++, itemZ++) {

                                matrix[i][itemZ] = matrix[nextNoNull][itemY];
                                if (matrix[nextNoNull][itemY] != Double.NEGATIVE_INFINITY) {
                                    flags[i][itemZ] = true;
                                }
                            }
                        }

                    }
                }
            }
            lastNoNull = i;
        }

    }

    public void entireRowInterpolation() {
        int lastNoNull = -1;
        for (int i = 0; i < interpolatedInitPositions.length; i++) {

            if (initPositions[i] == -1) {
                int nextNoNull = -1;
                for (int j = i; j < rows; j++) {
                    if (initPositions[j] != -1) {
                        nextNoNull = j;
                        break;
                    }
                }
                if (lastNoNull != -1 && nextNoNull != -1) {

                    for (int itemX = interpolatedInitPositions[lastNoNull],
                            itemY = interpolatedInitPositions[nextNoNull],
                            itemZ = interpolatedInitPositions[i];
                            itemX < cols && itemY < cols && itemZ < cols;
                            itemX++, itemY++, itemZ++) {
                        if (matrix[lastNoNull][itemX] != Double.NEGATIVE_INFINITY && matrix[nextNoNull][itemY] != Double.NEGATIVE_INFINITY) {
                            double xi = 1 / (matrix[lastNoNull][itemX] + matrix[nextNoNull][itemY]);
                            matrix[i][itemZ] = (matrix[nextNoNull][itemY] - matrix[lastNoNull][itemX]) * xi + matrix[lastNoNull][itemX];
                            flags[i][itemZ] = true;
                        } else {
                            matrix[i][itemZ] = Double.NEGATIVE_INFINITY;
                        }

                    }
                } else {
                    if (lastNoNull != -1) {
                        for (int itemX = interpolatedInitPositions[lastNoNull],
                                itemZ = interpolatedInitPositions[i];
                                itemX < cols && itemZ < cols;
                                itemX++, itemZ++) {

                            matrix[i][itemZ] = matrix[lastNoNull][itemX];
                            if (matrix[lastNoNull][itemX] != Double.NEGATIVE_INFINITY) {
                                flags[i][itemZ] = true;
                            }
                        }
                    } else {
                        if (nextNoNull != -1) {
                            for (int itemY = interpolatedInitPositions[nextNoNull],
                                    itemZ = interpolatedInitPositions[i];
                                    itemY < cols && itemZ < cols;
                                    itemY++, itemZ++) {

                                matrix[i][itemZ] = matrix[nextNoNull][itemY];
                                if (matrix[nextNoNull][itemY] != Double.NEGATIVE_INFINITY) {
                                    flags[i][itemZ] = true;
                                }
                            }
                        }

                    }
                }
            }
            lastNoNull = i;
        }

    }

    public int[] getInitialPositions() {
        return initPositions;
    }

    public int[] getInterpolatedInitialPositions() {
        return interpolatedInitPositions;
    }

    public void replaceNegativeInfinite() {
        int interpolatedLackNumberVar = 0;
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (matrix[i][j] == Double.NEGATIVE_INFINITY) {

                    this.matrix[i][j] = -1;
                    interpolatedLackNumberVar++;

                }
            }

        }
        this.interpolatedLackNumber = interpolatedLackNumberVar;

    }

    public void replaceNegativeInfiniteEmpty() {
        int interpolatedLackNumberVar = 0;
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {

                this.originalMatrix[i][j] = Double.NaN;
                this.matrix[i][j] = -1;
                interpolatedLackNumberVar++;

            }

        }
        this.interpolatedLackNumber = interpolatedLackNumberVar;

    }

    public BufferedImage getBufferedImage() {
        BufferedImage b = new BufferedImage(cols, rows, 3);
        Color[] colors = (new PseudoRainbow()).getColorScale();
        for (int y = 0; y < cols; y++) {
            for (int x = 0; x < rows; x++) {
                if (matrix[x][y] != Double.NEGATIVE_INFINITY && matrix[x][y] != -1) {
                    int rgb = colors[(int) matrix[x][y]].getRGB();
                    b.setRGB(y, x, rgb);
                } else {

                    b.setRGB(y, x, Color.gray.getRGB());

                }
            }
        }

        return b;

    }

    @Override
    public Matrix clone() throws CloneNotSupportedException {
        Matrix clone = new Matrix();
        clone.cols = this.cols;
        clone.flags = this.flags.clone();
        clone.initPositions = this.initPositions.clone();
        clone.interpolatedInitPositions = this.interpolatedInitPositions.clone();
        clone.interpolatedLackNumber = this.interpolatedLackNumber;
        clone.matrix = this.matrix.clone();
        clone.maxValue = this.maxValue;
        clone.minValue = this.minValue;
        clone.originalLackNumber = this.originalLackNumber;
        clone.originalMatrix = this.originalMatrix.clone();
        clone.rows = this.rows;

        return clone;

    }

    public static void main(String[] args) {

        Matrix matrixExample = new Matrix(10, 8);
        matrixExample.setValue(2, 3, -1);
        matrixExample.setValue(4, 3, -1);
        matrixExample.setValue(4, 4, 10);
        matrixExample.setValue(1, 3, 270);
        matrixExample.setValue(1, 1, 270);
        matrixExample.print();
        System.out.println("............");
        matrixExample.normalize();
        matrixExample.print();
        System.out.println("............");
        matrixExample.linearColInterpolation();
        matrixExample.replaceNegativeInfinite();
        matrixExample.print();

        int[][] MyMat = new int[2][5];
        MyMat[0][0] = 0;
        MyMat[0][1] = 1;
        MyMat[0][2] = 2;
        MyMat[0][3] = 3;
        MyMat[0][4] = 4;
        MyMat[1][0] = 9;
        MyMat[1][1] = 8;
        MyMat[1][2] = 7;
        MyMat[1][3] = 6;
        MyMat[1][4] = 5;

// get your columns... (easy)
        int[] My0 = MyMat[0]; //My0 = {0,1,2,3,4}
        int[] My1 = MyMat[1]; //My1 = {9,8,7,6,5}
        
        for(int i=0; i< My0.length;i++)
        {
            System.out.print(My0[i]+" ");
        }
        System.out.println();
        
             for(int i=0; i< My1.length;i++)
        {
            System.out.print(My1[i]+" ");
        }
        System.out.println();

// get the rows... (manually)
        int[] My_0 = new int[]{MyMat[0][0], MyMat[1][0]}; //My_0 = {0,9}
        int[] My_1 = new int[]{MyMat[0][1], MyMat[1][1]}; //My_1 = {1,8}
        int[] My_2 = new int[]{MyMat[0][2], MyMat[1][2]}; //My_2 = {2,7}
        int[] My_3 = new int[]{MyMat[0][3], MyMat[1][3]}; //My_3 = {3,6}
        int[] My_4 = new int[]{MyMat[0][4], MyMat[1][4]}; //My_4 = {4,5}
/*
// get the rows... (as a for-loop)
        int size = MyMat.length;
        int[] My_0 = new int[size]; //My_0 = {0,9}
        int[] My_1 = new int[size]; //My_1 = {1,8}
        int[] My_2 = new int[size]; //My_2 = {2,7}
        int[] My_3 = new int[size]; //My_3 = {3,6}
        int[] My_4 = new int[size]; //My_4 = {4,5}
        for (int i = 0; i < size; i++) {
            My_0[i] = MyMat[i][0];
            My_1[i] = MyMat[i][1];
            My_2[i] = MyMat[i][2];
            My_3[i] = MyMat[i][3];
            My_4[i] = MyMat[i][4];
        }*/

    }

}
