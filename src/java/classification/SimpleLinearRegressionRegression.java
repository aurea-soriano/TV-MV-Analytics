/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package classification;

import java.util.Random;
import java.util.concurrent.locks.Lock;
import java.util.logging.Level;
import java.util.logging.Logger;
import weka.classifiers.Evaluation;
import weka.classifiers.functions.SimpleLinearRegression;
import weka.core.FastVector;
import weka.core.Instances;
import weka.core.converters.ConverterUtils;

/**
 *
 * @author aurea
 */
public class SimpleLinearRegressionRegression  implements Classifier {

    Instances[] trainingSplits;
    Instances[] testingSplits;
    FastVector predictions;

    Lock lock = new java.util.concurrent.locks.ReentrantLock();

    @Override
    public String classify(String dataPath) {
        String resultClassifier = "Linear Regression \n\n";
        try {

            ConverterUtils.DataSource fonte = new ConverterUtils.DataSource(dataPath);
            Instances data = fonte.getDataSet();
            if (data.classIndex() == -1) {
                data.setClassIndex(data.numAttributes() - 1);
            }

            SimpleLinearRegression simpleLinearRegression = new SimpleLinearRegression();
            simpleLinearRegression.buildClassifier(data);
            resultClassifier += simpleLinearRegression.toString() + "\n";

            Evaluation crossVal;
            crossVal = new Evaluation(data);
            crossVal.crossValidateModel(simpleLinearRegression, data, 10, new Random(1));
            resultClassifier += crossVal.toSummaryString() + "\n";

        } catch (Exception ex) {
            Logger.getLogger(LinearRegressionRegression.class.getName()).log(Level.SEVERE, null, ex);
        }
        return resultClassifier;
    }

    @Override
    public String classify(Instances data) {
        String resultClassifier = "Linear Regression  \n\n";
        try {

            if (data.classIndex() == -1) {
                data.setClassIndex(data.numAttributes() - 1);
            }

            SimpleLinearRegression simpleLinearRegression = new SimpleLinearRegression();
            simpleLinearRegression.buildClassifier(data);
            resultClassifier += simpleLinearRegression.toString() + "\n";

            Evaluation crossVal;
            crossVal = new Evaluation(data);
            crossVal.crossValidateModel(simpleLinearRegression, data, 10, new Random(1));
            resultClassifier += crossVal.toSummaryString() + "\n";

            //resultClassifier += linearRegression.toString();
        } catch (Exception ex) {
            Logger.getLogger(LinearRegressionRegression.class.getName()).log(Level.SEVERE, null, ex);
        }
        return resultClassifier;
    }

    @Override
    public Instances[][] crossValidationSplit(Instances data, int numberOfFolds
    ) {
        Instances[][] split = new Instances[2][numberOfFolds];
        for (int i = 0; i < numberOfFolds; i++) {
            split[0][i] = data.trainCV(numberOfFolds, i);
            split[1][i] = data.testCV(numberOfFolds, i);
        }
        return split;
    }

    @Override
    public Evaluation classifyEvaluation(Instances trainingSet, Instances testingSet) {
        Evaluation evaluation = null;
        try {
            evaluation = new Evaluation(trainingSet);
            SimpleLinearRegression simpleLinearRegression = new SimpleLinearRegression();
            simpleLinearRegression.buildClassifier(trainingSet);
            evaluation.evaluateModel(simpleLinearRegression, testingSet);

        } catch (Exception ex) {
            Logger.getLogger(LinearRegressionRegression.class.getName()).log(Level.SEVERE, null, ex);
        }
        return evaluation;

    }
  public int classifyGetIndex(Instances data) {
        String resultClassifier = "Linear Regression  \n\n";
        int coeff = -1;
        try {

            if (data.classIndex() == -1) {
                data.setClassIndex(data.numAttributes() - 1);
            }

            SimpleLinearRegression linearRegression = new SimpleLinearRegression();
            linearRegression.buildClassifier(data);
            resultClassifier += linearRegression.toString() + "\n";
            coeff = linearRegression.getAttributeIndex();
            
           

            Evaluation crossVal;
            crossVal = new Evaluation(data);
            crossVal.crossValidateModel(linearRegression, data, 10, new Random(1));
            resultClassifier += crossVal.toSummaryString() + "\n";

            //resultClassifier += linearRegression.toString();
        } catch (Exception ex) {
            Logger.getLogger(LinearRegressionRegression.class.getName()).log(Level.SEVERE, null, ex);
        }
        return coeff;
    }
    @Override
    public double resultClassify(Instances data) {
          double accuracy = 0.0;
        try {

            if (data.classIndex() == -1) {
                data.setClassIndex(data.numAttributes() - 1);
            }

            SimpleLinearRegression simpleLinearRegression = new SimpleLinearRegression();
            simpleLinearRegression.buildClassifier(data);
            
            Evaluation crossVal;
            crossVal = new Evaluation(data);
            crossVal.crossValidateModel(simpleLinearRegression, data, 10, new Random(1));
            accuracy = crossVal.correlationCoefficient();

            //resultClassifier += linearRegression.toString();
        } catch (Exception ex) {
            Logger.getLogger(LinearRegressionRegression.class.getName()).log(Level.SEVERE, null, ex);
        }
        return accuracy;
    }

}

