/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package matrix.pointsmatrix;

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
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.StringTokenizer;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Fernando Vieira Paulovich
 */
public class DenseMatrix extends AbstractMatrix {
    @Override
    public void addRow(AbstractVector vector) {
        assert (vector instanceof DenseVector) : "ERROR: vector of wrong type!";

        super.addRow(vector);
    }

    @Override
    public void setRow(int index, AbstractVector vector) {
        assert (vector instanceof DenseVector) : "ERROR: vector of wrong type!";

        super.setRow(index, vector);
    }

    @Override
    public void load(String filename) throws IOException {
        this.rows = new ArrayList<>();
        this.attributes = new ArrayList<>();

        BufferedReader in = null;

        try {
            in = new BufferedReader(new FileReader(filename));

            //read the header
            char[] header = in.readLine().trim().toCharArray();

            //checking
            if (header.length != 2) {
                throw new IOException("Wrong format of header information.");
            }

            //checking
            if (header[0] != 'D') {
                throw new IOException("Wrong matrix format. It is not the dense format.");
            }

            //read the number of objects
            int nrobjs = Integer.parseInt(in.readLine());

            //read the number of dimensions
            int nrdims = Integer.parseInt(in.readLine());

            //read the attributes
            String line = in.readLine();
            StringTokenizer t1 = new StringTokenizer(line, ";");

            while (t1.hasMoreTokens()) {
                String token = t1.nextToken();
                this.attributes.add(token.trim());
            }

            //checking
            if (this.attributes.size() > 0 && this.attributes.size() != nrdims) {
                throw new IOException("The number of attributes does not match "
                        + "with the dimensionality of matrix (" + this.attributes.size()
                        + " - " + nrdims + ").");
            }

            //read the vectors
            while ((line = in.readLine()) != null && line.trim().length() > 0) {
                StringTokenizer t2 = new StringTokenizer(line, ";");

                //read the id
                String id = t2.nextToken().trim();

                //class data
                float klass = 0.0f;

                //the vector
                float[] vector = new float[nrdims];

                int index = 0;
                while (t2.hasMoreTokens()) {
                    String token = t2.nextToken();
                    float value = Float.parseFloat(token.trim());

                    if (header[1] == 'Y') {
                        if (t2.hasMoreTokens()) {
                            if (index < nrdims) {
                                vector[index] = value;
                                index++;
                            } else {
                                throw new IOException("Vector with wrong number of "
                                        + "dimensions!");
                            }
                        } else {
                            klass = value;
                        }
                    } else if (header[1] == 'N') {
                        if (index < nrdims) {
                            vector[index] = value;
                            index++;
                        } else {
                            throw new IOException("Vector with wrong number of "
                                    + "dimensions!");
                        }
                    } else {
                        throw new IOException("Unknown class data option");
                    }
                }

                //test if the id is an integer
                if (utils.Util.isParsableToInt(id)) {
                    this.addRow(new DenseVector(vector, Integer.parseInt(id), klass));
                } else {
                    this.addRow(new DenseVector(vector, utils.Util.convertToInt(id), klass), id);
                }
            }

            //checking
            if (this.getRowCount() != nrobjs) {
                throw new IOException("The number of vectors does not match "
                        + "with the matrix size (" + this.getRowCount()
                        + " - " + nrobjs + ").");
            }

        } catch (FileNotFoundException e) {
            throw new IOException("File " + filename + " does not exist!");
        } catch (IOException e) {
            throw new IOException(e.getMessage());
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (IOException ex) {
                    Logger.getLogger(DenseMatrix.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }

    @Override
    public void save(String filename) throws IOException {
        BufferedWriter out = null;

        try {
            out = new BufferedWriter(new FileWriter(filename));

            //Writting the file header
            out.write("DY\r\n");
            out.write(Integer.toString(this.getRowCount()));
            out.write("\r\n");
            out.write(Integer.toString(this.getDimensions()));
            out.write("\r\n");

            //Writting the attributes
            if (attributes != null) {
                for (int i = 0; i < attributes.size(); i++) {
                    out.write(attributes.get(i).replaceAll("<>", " ").trim());

                    if (i < attributes.size() - 1) {
                        out.write(";");
                    }
                }
                out.write("\r\n");
            } else {
                out.write("\r\n");
            }

            //writting the vectors            
            for (int i = 0; i < this.getRowCount(); i++) {
                //writting the id
                if (labels.size() > 0) {
                    out.write(labels.get(i));
                } else {
                    out.write(Integer.toString(this.rows.get(i).getId()));
                }
                out.write(";");

                //writting the coordinates
                this.rows.get(i).write(out);
                out.write("\r\n");
            }

        } catch (IOException ex) {
            throw new IOException("Problems written \"" + filename + "\"!");
        } finally {
            //close the file
            if (out != null) {
                try {
                    out.flush();
                    out.close();
                } catch (IOException ex) {
                    Logger.getLogger(DenseMatrix.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
    }

    @Override
    public Object clone() throws CloneNotSupportedException {
        DenseMatrix clone = new DenseMatrix();
        clone.dimensions = this.dimensions;

        for (String lab : this.labels) {
            clone.labels.add(lab);
        }

        for (String attr : this.attributes) {
            clone.attributes.add(attr);
        }

        for (AbstractVector v : this.rows) {
            clone.rows.add((DenseVector) v.clone());
        }

        return clone;
    }

}
