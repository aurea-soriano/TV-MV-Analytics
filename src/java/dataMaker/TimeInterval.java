/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dataMaker;

import java.util.ArrayList;
import matrix.pointsmatrix.AbstractVector;

/**
 *
 * @author aurea
 */
public class TimeInterval implements Cloneable {

    Matrix matrix;
    String initDate;
    String endDate;
    Integer initHour;
    Integer endHour;
    String nameAttribute;
    Integer cluster;
    AbstractVector moments;
    Integer indexColorCluster;
    ArrayList<String> listLabelsX;
    ArrayList<String> listLabelsY;
    String nameSource;
    String valueSource;
    String idSource;
    String nameSource2;
    String idSource2;
    String categorySource;
    float originalMissingDataImpact = 100.f;
    float interpolatedMissingDataImpact = 100.f;
    Integer index;

    public TimeInterval() {
        this.indexColorCluster = 0;
    }

    public TimeInterval(Matrix matrix, String initDate, String endDate,
            Integer initHour, Integer endHour, String nameAttribute, Integer cluster,
            ArrayList<String> listLabelsX, ArrayList<String> listLabelsY, 
            String nameSource, String valueSource, String idSource, String nameSource2, String idSource2,
            String categorySource, Integer index) {
        this.matrix = matrix;
        this.initDate = initDate;
        this.endDate = endDate;
        this.initHour = initHour;
        this.endHour = endHour;
        this.nameAttribute = nameAttribute;
        this.cluster = cluster;
        this.indexColorCluster = 0;
        this.listLabelsX = listLabelsX;
        this.listLabelsY = listLabelsY;
        this.nameSource = nameSource;
        this.valueSource = valueSource;
        this.idSource = idSource;
        this.nameSource2 = nameSource2;
        this.idSource2 = idSource2;
        this.categorySource = categorySource;
        this.index = index;
    }

    public Integer getIndex() {
        return index;
    }

    public void setIndex(Integer index) {
        this.index = index;
    }
    
    

    public boolean isEmpty() {

        return matrix.isEmpty();
    }

    public ArrayList<String> getListLabelsX() {
        return listLabelsX;
    }

    public void setListLabelsX(ArrayList<String> listLabelsX) {
        this.listLabelsX = listLabelsX;
    }

    public ArrayList<String> getListLabelsY() {
        return listLabelsY;
    }

    public void setListLabelsY(ArrayList<String> listLabelsY) {
        this.listLabelsY = listLabelsY;
    }

    public Matrix getMatrix() {
        return matrix;
    }

    public Matrix getProcessedMatrix() {

        int originalLackNumber = 0;
        int interpolatedLackNumber = 0;
        float originalImpact = 100.f;
        float interpolatedImpact = 100.f;
        if (matrix.isEmpty()) {
            matrix.replaceNegativeInfiniteEmpty();
        } else {
            matrix.normalize();
            matrix.calculateInitialPositions();
            matrix.rowAndColLinearInterpolation();
            // matrix.rowInterpolation();
            matrix.replaceNegativeInfinite();
            originalLackNumber = matrix.countOriginalLacks();
            interpolatedLackNumber = matrix.countInterpolatedLacks();
            int cellNumber = matrix.getCols() * matrix.getRows();

            originalImpact = (originalLackNumber * 100.f) / cellNumber;
            interpolatedImpact = (interpolatedLackNumber * 100.f) / cellNumber;

            originalImpact = (float) Math.round(originalImpact * 10) / 10;
            interpolatedImpact = (float) Math.round(interpolatedImpact * 10) / 10;
        }

        this.originalMissingDataImpact = originalImpact;
        this.interpolatedMissingDataImpact = interpolatedImpact;

        return matrix;
    }

    public float getOriginalMissingDataImpact() {
        return originalMissingDataImpact;
    }

    public float getInterpolatedMissingDataImpact() {
        return interpolatedMissingDataImpact;
    }

    public void setMatrix(Matrix matrix) {
        this.matrix = matrix;
    }

    public String getInitDate() {
        return initDate;
    }

    public void setInitDate(String initDate) {
        this.initDate = initDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public String getNameAttribute() {
        return nameAttribute;
    }

    public void setNameAttribute(String nameAttribute) {
        this.nameAttribute = nameAttribute;
    }

    public Integer getCluster() {
        return cluster;
    }

    public void setCluster(Integer cluster) {
        this.cluster = cluster;
    }

    public Integer getInitHour() {
        return initHour;
    }

    public void setInitHour(Integer initHour) {
        this.initHour = initHour;
    }

    public Integer getEndHour() {
        return endHour;
    }

    public void setEndHour(Integer endHour) {
        this.endHour = endHour;
    }

    public AbstractVector getMoments() {
        return moments;
    }

    public void setMoments(AbstractVector moments) {
        this.moments = moments;
    }

    public Integer getIndexColorCluster() {
        return indexColorCluster;
    }

    public void setIndexColorCluster(Integer indexColorCluster) {
        this.indexColorCluster = indexColorCluster;
    }

    public String getValueSource() {
        return valueSource;
    }

    public void setValueSource(String valueSource) {
        this.valueSource = valueSource;
    }

    public String getNameSource() {
        return nameSource;
    }

    public void setNameSource(String nameSource) {
        this.nameSource = nameSource;
    }

    public String getNameSource2() {
        return nameSource2;
    }

    public void setNameSource2(String nameSource2) {
        this.nameSource2 = nameSource2;
    }

    public String getIdSource2() {
        return idSource2;
    }

    public void setIdSource2(String idSource2) {
        this.idSource2 = idSource2;
    }

    public String getIdSource() {
        return idSource;
    }

    public void setIdSource(String idSource) {
        this.idSource = idSource;
    }

    public String getCategorySource() {
        return categorySource;
    }

    public void setCategorySource(String categorySource) {
        this.categorySource = categorySource;
    }

    @Override
    public TimeInterval clone() throws CloneNotSupportedException {

                    
        TimeInterval clone = new TimeInterval();
        clone.matrix = this.matrix.clone();
        clone.categorySource = this.categorySource;
        clone.cluster = this.cluster;
        clone.endDate = this.endDate;
        clone.endHour = this.endHour;
        clone.idSource = this.idSource;
        clone.idSource2 = this.idSource2;
        clone.indexColorCluster = this.indexColorCluster;
        clone.initDate = this.initDate;
        clone.initHour = this.initHour;
        clone.interpolatedMissingDataImpact = this.interpolatedMissingDataImpact;
        clone.listLabelsX = (ArrayList<String>) this.listLabelsX.clone();
        clone.listLabelsY = (ArrayList<String>) this.listLabelsY.clone();
        clone.moments = (AbstractVector) this.moments.clone();
        clone.nameAttribute = this.nameAttribute;
        clone.nameSource = this.nameSource;
        clone.nameSource2 = this.nameSource2;
        clone.originalMissingDataImpact = this.originalMissingDataImpact;
        clone.valueSource = this.valueSource;
        clone.index = this.index;
        
        
        return clone;
    }

}
