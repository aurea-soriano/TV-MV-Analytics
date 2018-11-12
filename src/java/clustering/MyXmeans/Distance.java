/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package clustering.MyXmeans;

/**
 * An interface to calculate a distance measure between two objects. A distance
 * function maps pairs of points into the nonnegative reals and has to satisfy
 * <ul>
 * <li> non-negativity: d(x, y) &ge; 0
 * <li> isolation: d(x, y) = 0 if and only if x = y
 * <li> symmetry: d(x, y) = d(x, y)
 * </ul>.
 * Note that a distance function is not required to satisfy triangular inequality
 * |x - y| + |y - z| &ge; |x - z|, which is necessary for a metric.
 *
 * @author Haifeng Li
 */
public interface Distance<T> {
    /**
     * Returns the distance measure between two objects.
     */
    public double d(T x, T y);
}