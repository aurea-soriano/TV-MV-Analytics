/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package projection;

import java.io.IOException;
import matrix.distancematrix.DistanceMatrix;
import distance.AbstractDissimilarity;
import matrix.pointsmatrix.AbstractMatrix;

/**
 *
 * @author Fernando V. Paulovic
 */
public interface Projection {

    public AbstractMatrix project(AbstractMatrix matrix, AbstractDissimilarity diss) throws IOException;

    public AbstractMatrix project(DistanceMatrix dmat) throws IOException;

}
