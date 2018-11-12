/* ***** BEGIN LICENSE BLOCK *****
 *
 * Copyright (c) 2005-2007 Universidade de Sao Paulo, Sao Carlos/SP, Brazil.
 * All Rights Reserved.
 *
 * This file is part of Projection Explorer (PEx).
 *
 * How to cite this work:
 *  
@inproceedings{paulovich2007pex,
author = {Fernando V. Paulovich and Maria Cristina F. Oliveira and Rosane 
Minghim},
title = {The Projection Explorer: A Flexible Tool for Projection-based 
Multidimensional Visualization},
booktitle = {SIBGRAPI '07: Proceedings of the XX Brazilian Symposium on 
Computer Graphics and Image Processing (SIBGRAPI 2007)},
year = {2007},
isbn = {0-7695-2996-8},
pages = {27--34},
doi = {http://dx.doi.org/10.1109/SIBGRAPI.2007.39},
publisher = {IEEE Computer Society},
address = {Washington, DC, USA},
}
 *  
 * PEx is free software: you can redistribute it and/or modify it under 
 * the terms of the GNU General Public License as published by the Free 
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * PEx is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
 * for more details.
 *
 * This code was developed by members of Computer Graphics and Image
 * Processing Group (http://www.lcad.icmc.usp.br) at Instituto de Ciencias
 * Matematicas e de Computacao - ICMC - (http://www.icmc.usp.br) of 
 * Universidade de Sao Paulo, Sao Carlos/SP, Brazil. The initial developer 
 * of the original code is Fernando Vieira Paulovich <fpaulovich@gmail.com>.
 *
 * Contributor(s): Rosane Minghim <rminghim@icmc.usp.br>
 *
 * You should have received a copy of the GNU General Public License along 
 * with PEx. If not, see <http://www.gnu.org/licenses/>.
 *
 * ***** END LICENSE BLOCK ***** */

package matrix.pointsmatrix;

import java.util.ArrayList;
import java.util.Arrays;

/**
 *
 * @author Fernando Vieira Paulovich
 */
public class MatrixUtils {
    public static AbstractVector mean(AbstractMatrix matrix) {
        assert (matrix.getRowCount() > 0) : "More than zero vectors must be used!";

        if (matrix instanceof SparseMatrix) {
            float[] mean = new float[matrix.getDimensions()];
            Arrays.fill(mean, 0.0f);

            int size = matrix.getRowCount();
            for (int i = 0; i < size; i++) {
                int[] index = ((SparseVector) matrix.getRow(i)).getIndex();
                float[] values = matrix.getRow(i).getValues();

                for (int j = 0; j < index.length; j++) {
                    mean[index[j]] += values[j];
                }
            }

            for (int j = 0; j < mean.length; j++) {
                mean[j] = mean[j] / size;
            }

            return new SparseVector(mean);

        } else if (matrix instanceof DenseMatrix) {
            float[] mean = new float[matrix.getDimensions()];
            Arrays.fill(mean, 0.0f);

            int size = matrix.getRowCount();
            for (int i = 0; i < size; i++) {
                float[] values = matrix.getRow(i).getValues();

                for (int j = 0; j < values.length; j++) {
                    mean[j] += values[j];
                }
            }

            for (int j = 0; j < mean.length; j++) {
                mean[j] = mean[j] / size;
            }

            return new DenseVector(mean);
        }

        return null;
    }

    public static SparseMatrix convert(DenseMatrix matrix) {
        SparseMatrix newmatrix = new SparseMatrix();

        newmatrix.setAttributes(matrix.getAttributes());

        for (int i = 0; i < matrix.getRowCount(); i++) {
            AbstractVector dv = matrix.getRow(i);
            newmatrix.addRow(new SparseVector(dv.toArray(), dv.getId(), dv.getKlass()));
        }

        return newmatrix;
    }

    public static DenseMatrix convert(SparseMatrix matrix) {
        DenseMatrix newmatrix = new DenseMatrix();

        newmatrix.setAttributes(matrix.getAttributes());

        for (int i = 0; i < matrix.getRowCount(); i++) {
            AbstractVector dv = matrix.getRow(i);
            newmatrix.addRow(new DenseVector(dv.toArray(), dv.getId(), dv.getKlass()));
        }

        return newmatrix;
    }

    //return two array lists with the minimun and maximum values of each dimension
    //first is the min and the second is the max
    public static ArrayList<ArrayList<Float>> getMinMax(AbstractMatrix matrix) {
        ArrayList<Float> min = new ArrayList<>();
        ArrayList<Float> max = new ArrayList<>();

        if (matrix.getDimensions() > 0) {
            float[] array = matrix.getRow(0).toArray();
            for (int j = 0; j < array.length; j++) {
                min.add(array[j]);
                max.add(array[j]);
            }

            for (int i = 1; i < matrix.getRowCount(); i++) {
                array = matrix.getRow(i).toArray();

                for (int j = 0; j < array.length; j++) {
                    if (max.get(j) < array[j]) {
                        max.set(j, array[j]);
                    } else if (min.get(j) > array[j]) {
                        min.set(j, array[j]);
                    }
                }
            }
        }

        ArrayList<ArrayList<Float>> maxmin = new ArrayList<>();
        maxmin.add(min);
        maxmin.add(max);

        return maxmin;
    }

    public static ArrayList<MinMax> getMinMax2(AbstractMatrix matrix) {
        ArrayList<MinMax> mm = new ArrayList<>();

        if (matrix.getDimensions() > 0) {
            for (int i = 0; i < matrix.getDimensions(); i++) {
                mm.add(new MinMax());
            }

            for (int i = 0; i < matrix.getRowCount(); i++) {
                float[] array = matrix.getRow(i).toArray();

                for (int j = 0; j < array.length; j++) {
                    if (mm.get(j).max < array[j]) {
                        mm.get(j).max = array[j];
                    }

                    if (mm.get(j).min > array[j]) {
                        mm.get(j).min = array[j];
                    }
                }
            }
        }

        return mm;
    }

    public static class MinMax {

        public float max = Float.NEGATIVE_INFINITY;
        public float min = Float.POSITIVE_INFINITY;
    }
}
