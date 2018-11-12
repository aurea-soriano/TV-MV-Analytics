/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package matrix.pointsmatrix;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;

/**
 *
 * @author aurea
 */
public class BinaryMatrixReader {

    public DenseMatrix read(String filename) throws IOException {
        DenseMatrix matrix = new DenseMatrix();

        ArrayList<Float> cdata = new ArrayList<>();
        float[][] points = read(filename, cdata);

        ArrayList<String> attrib = new ArrayList<>();
        for (int i = 0; i < points[0].length; i++) {
            attrib.add("attr");
        }

        matrix.setAttributes(attrib);

        for (int i = 0; i < points.length; i++) {
            matrix.addRow(new DenseVector(points[i], i, cdata.get(i)));
        }

        return matrix;
    }

    private float[][] read(String filename, ArrayList<Float> cdata) throws IOException {
        BufferedInputStream bis = null;
        DataInputStream dis = null;

        try {
            bis = new BufferedInputStream(new FileInputStream(filename));
            dis = new DataInputStream(bis);

            int nrelements = dis.readInt(); //getting the number of elements
            int nrdimensions = dis.readInt(); //getting the number of dimensions

            //creating the points matrix
            float[][] points = new float[nrelements][];
            for (int i = 0; i < points.length; i++) {
                points[i] = new float[nrdimensions];
            }

            for (float[] point : points) {
                //reading the coordinates
                for (int j = 0; j < point.length; j++) {
                    point[j] = dis.readFloat();
                }
                //reading the cdata
                cdata.add(dis.readFloat());
            }

            return points;
        } catch (IOException ex) {
            throw new IOException(ex);
        } finally {
            try {
                if (dis != null) {
                    dis.close();
                }

                if (bis != null) {
                    bis.close();
                }
            } catch (IOException ex) {
                throw new IOException(ex);
            }
        }
    }
}
