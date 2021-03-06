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

package projection.util;


import clustering.neighbors.Pair;
import java.io.IOException;
import java.util.HashSet;
import java.util.Iterator;
import java.util.TreeSet;
import java.util.logging.Level;
import java.util.logging.Logger;
import matrix.distancematrix.DistanceMatrix;
import distance.AbstractDissimilarity;
import matrix.pointsmatrix.AbstractMatrix;


/**
 *
 * @author Fernando Vieira Paulovich
 */
public class MeshGenerator {

    public Pair[][] execute(Pair[][] neighbors, DistanceMatrix dmat) {
        long start = System.currentTimeMillis();

        //ensuring that the mesh is entirely connected
        HashSet<Integer> visited = new HashSet<>();
        HashSet<Integer> tovisit = new HashSet<>();
        HashSet<Integer> notvisited = new HashSet<>();

        tovisit.add(0);
        for (int i = 1; i < neighbors.length; i++) {
            notvisited.add(i);
        }

        while (notvisited.size() > 0) {
            if (tovisit.size() > 0) {
                int next = tovisit.iterator().next();
                visited.add(next);
                tovisit.remove(next);
                notvisited.remove(next);

                for (Pair neighbor : neighbors[next]) {
                    if (!visited.contains(neighbor.index)) {
                        tovisit.add(neighbor.index);
                    }
                }
            } else {
                int next = notvisited.iterator().next();
                notvisited.remove(next);
                tovisit.add(next);

                Iterator<Integer> visited_it = visited.iterator();

                int closest = 0;
                float min = Float.MAX_VALUE;

                while (visited_it.hasNext()) {
                    int aux = visited_it.next();
                    float distance = dmat.getDistance(aux, next);

                    if (min > distance) {
                        min = distance;
                        closest = aux;
                    }
                }

                Pair[] newNeighbors1 = new Pair[neighbors[next].length + 1];
                System.arraycopy(neighbors[next], 0, newNeighbors1, 0, neighbors[next].length);

                newNeighbors1[neighbors[next].length] = new Pair(closest, min);
                neighbors[next] = newNeighbors1;

                Pair[] newNeighbors2 = new Pair[neighbors[closest].length + 1];
                System.arraycopy(neighbors[closest], 0, newNeighbors2, 0, neighbors[closest].length);

                newNeighbors2[neighbors[closest].length] = new Pair(next, min);
                neighbors[closest] = newNeighbors2;
            }
        }

        long finish = System.currentTimeMillis();

        Logger.getLogger(this.getClass().getName()).log(Level.INFO, "Creating the mesh time: {0}s", (finish - start) / 1000.0f);


        return neighbors;
    }

    public Pair[][] execute(Pair[][] neighbors, AbstractMatrix matrix,
            AbstractDissimilarity diss) throws IOException {
        long start = System.currentTimeMillis();

        //ensuring that the mesh is entirely connected
        TreeSet<Integer> visited = new TreeSet<>();
        TreeSet<Integer> tovisit = new TreeSet<>();
        TreeSet<Integer> notvisited = new TreeSet<>();

        tovisit.add(0);
        for (int i = 1; i < neighbors.length; i++) {
            notvisited.add(i);
        }

        while (notvisited.size() > 0) {
            if (tovisit.size() > 0) {
                int next = tovisit.first();
                visited.add(next);
                tovisit.remove(next);
                notvisited.remove(next);

                for (Pair neighbor : neighbors[next]) {
                    if (!visited.contains(neighbor.index)) {
                        tovisit.add(neighbor.index);
                    }
                }
            } else {
                int next = notvisited.first();
                notvisited.remove(next);
                tovisit.add(next);

                Iterator<Integer> visited_it = visited.iterator();

                int closest = 0;
                float min = Float.MAX_VALUE;

                while (visited_it.hasNext()) {
                    int aux = visited_it.next();
                    float distance = diss.calculate(matrix.getRow(aux), matrix.getRow(next));

                    if (min > distance) {
                        min = distance;
                        closest = aux;
                    }
                }

                Pair[] newNeighbors1 = new Pair[neighbors[next].length + 1];
                System.arraycopy(neighbors[next], 0, newNeighbors1, 0, neighbors[next].length);
                newNeighbors1[neighbors[next].length] = new Pair(closest, min);
                neighbors[next] = newNeighbors1;

                Pair[] newNeighbors2 = new Pair[neighbors[closest].length + 1];
                System.arraycopy(neighbors[closest], 0, newNeighbors2, 0, neighbors[closest].length);
                newNeighbors2[neighbors[closest].length] = new Pair(next, min);
                neighbors[closest] = newNeighbors2;
            }
        }

        long finish = System.currentTimeMillis();

        Logger.getLogger(this.getClass().getName()).log(Level.INFO, "Creating the mesh time: {0}s", (finish - start) / 1000.0f);

        return neighbors;
    }

}
