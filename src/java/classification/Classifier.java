/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package classification;

import weka.classifiers.Evaluation;
import weka.core.Instances;

/**
 *
 * @author aurea
 */
public interface Classifier {

    public String classify(String dataPath);

    public String classify(Instances data);

    public double resultClassify(Instances data);//accuracy or correlation

    public Evaluation classifyEvaluation(Instances trainingSet, Instances testingSet);

    public Instances[][] crossValidationSplit(Instances data, int numberOfFolds);

}
