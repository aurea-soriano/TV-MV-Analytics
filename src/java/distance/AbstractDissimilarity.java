/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package distance;

import matrix.pointsmatrix.AbstractVector;



/**
 *
 * @author Fernando Vieira Paulovich
 */
public interface AbstractDissimilarity {

    public float calculate(AbstractVector v1, AbstractVector v2);
    

}
