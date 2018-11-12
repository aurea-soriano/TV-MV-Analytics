/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utils;

import clustering.Clustering;
import dataMaker.TimeInterval;
import distance.AbstractDissimilarity;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import matrix.pointsmatrix.AbstractMatrix;
import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.Hours;
import org.joda.time.Minutes;
import org.joda.time.Months;
import org.joda.time.Years;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import weka.core.Attribute;
import weka.core.FastVector;
import weka.core.Instance;
import weka.core.Instances;
import classification.LinearRegressionRegression;
import classification.SimpleLinearRegressionRegression;

/**
 *
 * @author aurea
 */
public class Util {

    public static Integer distanceInHours(Integer initHour, Integer endHour) {

        if (endHour >= initHour) {
            return (endHour - initHour + 1);
        } else {
            return distanceInHours(initHour, 23) + distanceInHours(0, endHour);
        }
    }

    public static long getNumberRowsFromTimeUnit(Date initDate, Date endDate, String timeUnit) {
        long numberRows = 0;
        DateTime initTime = new DateTime(initDate.getTime());
        DateTime endTime = new DateTime(endDate.getTime());
        if (timeUnit.equals("minute")) {
            //then hour numberRows = (60 * 60 * 1000);
            numberRows = Hours.hoursBetween(initTime, endTime).getHours() + 1;
        } else {
            if (timeUnit.equals("hour")) {
                //then day  numberRows = (24 * 60 * 60 * 1000);
                numberRows = Days.daysBetween(initTime, endTime).getDays() + 1;

            } else {
                if (timeUnit.equals("day")) {
                    //then month numberRows = (30 * 60 * 60 * 1000);
                    numberRows = Months.monthsBetween(initTime, endTime).getMonths() + 1;
                } else {
                    if (timeUnit.equals("month")) {
                        //then year numberRows = (12 * 30 * 60 * 60 * 1000);
                        numberRows = Years.yearsBetween(initTime, endTime).getYears() + 1;
                    }
                }
            }
        }
        return numberRows;
    }

    public static ArrayList<String> getRowLabelsFromTimeUnit(Date initDate, Date endDate, String timeUnit) throws ParseException {

        DateTime initTime = new DateTime(initDate.getTime());
        DateTime endTime = new DateTime(endDate.getTime());
        ArrayList<String> listRowLabels = new ArrayList<String>();
        if (timeUnit.equals("minute")) {
            //then minute numberRows = (60 * 60 * 1000);
            long numberRows = Minutes.minutesBetween(initTime, endTime).getMinutes();
            DateTime dateTimeTmp = initTime;
            for (int i = 0; i <= numberRows; i++) {
                //String dateformat = sdf.format(dateTmp);
                String month = "";
                if (dateTimeTmp.getMonthOfYear() < 10) {
                    month = "0";
                }
                month += dateTimeTmp.getMonthOfYear();
                String day = "";
                if (dateTimeTmp.getDayOfMonth() < 10) {
                    day = "0";
                }
                day += dateTimeTmp.getDayOfMonth();
                String hour = "";
                if (dateTimeTmp.getHourOfDay() < 10) {
                    hour = "0";
                }
                hour += dateTimeTmp.getHourOfDay();
                String minute = "";
                if (dateTimeTmp.getMinuteOfHour() < 10) {
                    minute = "0";
                }
                minute += dateTimeTmp.getMinuteOfHour();

                listRowLabels.add(dateTimeTmp.getYear() + "-" + month + "-" + day + " " + hour + ":" + minute);
                dateTimeTmp = dateTimeTmp.plusMinutes(1);
            }

        } else {
            if (timeUnit.equals("hour")) {
                //then hour numberRows = (60 * 60 * 1000);
                long numberRows = Hours.hoursBetween(initTime, endTime).getHours();
                DateTime dateTimeTmp = initTime;
                for (int i = 0; i <= numberRows; i++) {
                    //String dateformat = sdf.format(dateTmp);
                    String month = "";
                    if (dateTimeTmp.getMonthOfYear() < 10) {
                        month = "0";
                    }
                    month += dateTimeTmp.getMonthOfYear();
                    String day = "";
                    if (dateTimeTmp.getDayOfMonth() < 10) {
                        day = "0";
                    }
                    day += dateTimeTmp.getDayOfMonth();
                    String hour = "";
                    if (dateTimeTmp.getHourOfDay() < 10) {
                        hour = "0";
                    }
                    hour += dateTimeTmp.getHourOfDay();

                    listRowLabels.add(dateTimeTmp.getYear() + "-" + month + "-" + day + " " + hour + ":00");
                    dateTimeTmp = dateTimeTmp.plusHours(1);
                }

            } else {
                if (timeUnit.equals("day")) {
                    //then day  numberRows = (24 * 60 * 60 * 1000);
                    long numberRows = Days.daysBetween(initTime, endTime).getDays();
                    DateTime dateTimeTmp = initTime;
                    for (int i = 0; i <= numberRows; i++) {
                        String month = "";
                        if (dateTimeTmp.getMonthOfYear() < 10) {
                            month = "0";
                        }
                        month += dateTimeTmp.getMonthOfYear();
                        String day = "";
                        if (dateTimeTmp.getDayOfMonth() < 10) {
                            day = "0";
                        }
                        day += dateTimeTmp.getDayOfMonth();
                        listRowLabels.add(dateTimeTmp.getYear() + "-" + month + "-" + day);
                        dateTimeTmp = dateTimeTmp.plusDays(1);
                    }

                } else {
                    if (timeUnit.equals("month")) {
                        //then month numberRows = (30 * 60 * 60 * 1000);
                        long numberRows = Months.monthsBetween(initTime, endTime).getMonths();
                        DateTime dateTimeTmp = initTime;
                        for (int i = 0; i <= numberRows; i++) {
                            String month = "";
                            if (dateTimeTmp.getMonthOfYear() < 10) {
                                month = "0";
                            }
                            month += dateTimeTmp.getMonthOfYear();
                            listRowLabels.add(dateTimeTmp.getYear() + "-" + month);
                            dateTimeTmp = dateTimeTmp.plusMonths(1);
                        }
                    } else {
                        if (timeUnit.equals("year")) {
                            //then year numberRows = (12 * 30 * 60 * 60 * 1000);
                            long numberRows = Years.yearsBetween(initTime, endTime).getYears();
                            DateTime dateTimeTmp = initTime;
                            for (int i = 0; i <= numberRows; i++) {
                                listRowLabels.add(dateTimeTmp.getYear() + "");
                                dateTimeTmp = dateTimeTmp.plusYears(1);
                            }
                        }
                    }
                }
            }
        }
        return listRowLabels;
    }

    public static String getPredictedLabelRow(String lastY, String timeUnit) throws ParseException {

        String predictedRow = "";
        if (timeUnit.equals("minute")) {
            //then minute numberRows = (60 * 60 * 1000);
            DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm");
            DateTime dateTimeTmp = formatter.parseDateTime(lastY);
            dateTimeTmp = dateTimeTmp.plusMinutes(1);

            String month = "";
            if (dateTimeTmp.getMonthOfYear() < 10) {
                month = "0";
            }
            month += dateTimeTmp.getMonthOfYear();
            String day = "";
            if (dateTimeTmp.getDayOfMonth() < 10) {
                day = "0";
            }
            day += dateTimeTmp.getDayOfMonth();
            String hour = "";
            if (dateTimeTmp.getHourOfDay() < 10) {
                hour = "0";
            }
            hour += dateTimeTmp.getHourOfDay();
            String minute = "";
            if (dateTimeTmp.getMinuteOfHour() < 10) {
                minute = "0";
            }
            minute += dateTimeTmp.getMinuteOfHour();

            predictedRow = dateTimeTmp.getYear() + "-" + month + "-" + day + " " + hour + ":" + minute;

        } else {
            if (timeUnit.equals("hour")) {
                //then minute numberRows = (60 * 60 * 1000);
                DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH");
                DateTime dateTimeTmp = formatter.parseDateTime(lastY);
                dateTimeTmp = dateTimeTmp.plusHours(1);
                String month = "";
                if (dateTimeTmp.getMonthOfYear() < 10) {
                    month = "0";
                }
                month += dateTimeTmp.getMonthOfYear();
                String day = "";
                if (dateTimeTmp.getDayOfMonth() < 10) {
                    day = "0";
                }
                day += dateTimeTmp.getDayOfMonth();
                String hour = "";
                if (dateTimeTmp.getHourOfDay() < 10) {
                    hour = "0";
                }
                hour += dateTimeTmp.getHourOfDay();

                predictedRow = dateTimeTmp.getYear() + "-" + month + "-" + day + " " + hour;

            } else {
                if (timeUnit.equals("day")) {
                    //then day  numberRows = (24 * 60 * 60 * 1000);
                    DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd");
                    DateTime dateTimeTmp = formatter.parseDateTime(lastY);
                    dateTimeTmp = dateTimeTmp.plusDays(1);
                    String month = "";
                    if (dateTimeTmp.getMonthOfYear() < 10) {
                        month = "0";
                    }
                    month += dateTimeTmp.getMonthOfYear();
                    String day = "";
                    if (dateTimeTmp.getDayOfMonth() < 10) {
                        day = "0";
                    }
                    day += dateTimeTmp.getDayOfMonth();

                    predictedRow = dateTimeTmp.getYear() + "-" + month + "-" + day;

                } else {
                    if (timeUnit.equals("month")) {
                        //then day  numberRows = (24 * 60 * 60 * 1000);
                        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM");
                        DateTime dateTimeTmp = formatter.parseDateTime(lastY);
                        dateTimeTmp = dateTimeTmp.plusMonths(1);
                        String month = "";
                        if (dateTimeTmp.getMonthOfYear() < 10) {
                            month = "0";
                        }
                        month += dateTimeTmp.getMonthOfYear();
                        predictedRow = dateTimeTmp.getYear() + "-" + month;
                    } else {
                        if (timeUnit.equals("year")) {
                            DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy");
                            DateTime dateTimeTmp = formatter.parseDateTime(lastY);
                            dateTimeTmp = dateTimeTmp.plusYears(1);
                            predictedRow = dateTimeTmp.getYear() + "";
                        }
                    }
                }
            }
        }
        //System.out.println("Last  Y "+ lastY+" Predicted row "+ predictedRow);
        return predictedRow;
    }

    public static String getPredictedEndDate(String endDate, String rowUnit) throws ParseException {

        String predictedEndDate = "";
        if (rowUnit.equals("minute")) {

            //then minute numberRows = (60 * 60 * 1000);
            DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd");
            DateTime dateTimeTmp = formatter.parseDateTime(endDate);
            dateTimeTmp = dateTimeTmp.plusMinutes(1);

            String month = "";
            if (dateTimeTmp.getMonthOfYear() < 10) {
                month = "0";
            }
            month += dateTimeTmp.getMonthOfYear();
            String day = "";
            if (dateTimeTmp.getDayOfMonth() < 10) {
                day = "0";
            }
            day += dateTimeTmp.getDayOfMonth();

            predictedEndDate = dateTimeTmp.getYear() + "-" + month + "-" + day;

        } else {
            if (rowUnit.equals("hour")) {
                //then minute numberRows = (60 * 60 * 1000);
                DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd");
                DateTime dateTimeTmp = formatter.parseDateTime(endDate);
                dateTimeTmp = dateTimeTmp.plusHours(1);
                String month = "";
                if (dateTimeTmp.getMonthOfYear() < 10) {
                    month = "0";
                }
                month += dateTimeTmp.getMonthOfYear();
                String day = "";
                if (dateTimeTmp.getDayOfMonth() < 10) {
                    day = "0";
                }
                day += dateTimeTmp.getDayOfMonth();

                predictedEndDate = dateTimeTmp.getYear() + "-" + month + "-" + day;

            } else {
                if (rowUnit.equals("day")) {
                    //then day  numberRows = (24 * 60 * 60 * 1000);
                    DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd");
                    DateTime dateTimeTmp = formatter.parseDateTime(endDate);
                    dateTimeTmp = dateTimeTmp.plusDays(1);
                    String month = "";
                    if (dateTimeTmp.getMonthOfYear() < 10) {
                        month = "0";
                    }
                    month += dateTimeTmp.getMonthOfYear();
                    String day = "";
                    if (dateTimeTmp.getDayOfMonth() < 10) {
                        day = "0";
                    }
                    day += dateTimeTmp.getDayOfMonth();

                    predictedEndDate = dateTimeTmp.getYear() + "-" + month + "-" + day;

                } else {
                    if (rowUnit.equals("month")) {
                        //then day  numberRows = (24 * 60 * 60 * 1000);
                        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd");
                        DateTime dateTimeTmp = formatter.parseDateTime(endDate);
                        dateTimeTmp = dateTimeTmp.plusMonths(1);
                        String month = "";
                        if (dateTimeTmp.getMonthOfYear() < 10) {
                            month = "0";
                        }
                        month += dateTimeTmp.getMonthOfYear();
                        String day = "";
                        if (dateTimeTmp.getDayOfMonth() < 10) {
                            day = "0";
                        }
                        day += dateTimeTmp.getDayOfMonth();

                        predictedEndDate = dateTimeTmp.getYear() + "-" + month + "-" + day;
                    } else {
                        if (rowUnit.equals("year")) {
                            DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd");
                            DateTime dateTimeTmp = formatter.parseDateTime(endDate);
                            dateTimeTmp = dateTimeTmp.plusYears(1);
                            String month = "";
                            if (dateTimeTmp.getMonthOfYear() < 10) {
                                month = "0";
                            }
                            month += dateTimeTmp.getMonthOfYear();
                            String day = "";
                            if (dateTimeTmp.getDayOfMonth() < 10) {
                                day = "0";
                            }
                            day += dateTimeTmp.getDayOfMonth();

                            predictedEndDate = dateTimeTmp.getYear() + "-" + month + "-" + day;
                        }
                    }
                }
            }
        }
        //System.out.println("End date "+ endDate+" Predicted day "+ predictedEndDate);
        return predictedEndDate;
    }

    public static void printListString(ArrayList<String> list) {
        for (int i = 0; i < list.size(); i++) {
            System.out.println(list.get(i));
        }
    }

    public static java.util.ArrayList<String> listTimeLabelsInHours(Integer initHour, Integer endHour, java.util.ArrayList<String> listHours) {

        if (endHour >= initHour) {
            for (int i = initHour; i <= endHour; i++) {
                listHours.add(String.valueOf(i));
            }
            return listHours;
        } else {
            return listTimeLabelsInHours(0, endHour, listTimeLabelsInHours(initHour, 23, listHours));

        }
    }

    public static java.util.ArrayList<String> listTimeLabelsWithSameTimeUnit(String timeUnit, Integer initTime, Integer endTime, Integer valueUnitTimeInterval) {
        java.util.ArrayList<String> listTimeLabels = new java.util.ArrayList<>();
        for (int aux = initTime; aux <= endTime; aux += valueUnitTimeInterval) {
            String strHourValue = "";
            if (timeUnit.equals("minute")) {
                if (aux < 10) {
                    strHourValue += "0";
                }
                strHourValue += (String.valueOf(aux) + ":00");
            } else if (timeUnit.equals("hour")) {
                if (aux < 10) {
                    strHourValue += "0";
                }
                strHourValue += (String.valueOf(aux) + ":00:00");
            } else if (timeUnit.equals("day")) {
                if (aux < 10) {
                    strHourValue += "day 0";
                } else {
                    strHourValue += "day ";
                }
                strHourValue += (String.valueOf(aux));
            } else if (timeUnit.equals("month")) {
                if (aux < 10) {
                    strHourValue += "month 0";
                } else {
                    strHourValue += "month ";
                }
                strHourValue += (String.valueOf(aux));
            } else if (timeUnit.equals("year")) {

                strHourValue += "year ";

                strHourValue += (String.valueOf(aux));
            }
            listTimeLabels.add(strHourValue);
        }
        return listTimeLabels;
    }

    public static java.util.ArrayList<String> getListColumnLabels(String unitTimeInterval, Integer valueUnitTimeInterval, String rowUnit) {

        ArrayList<String> listColumnLabels = new ArrayList<String>();

        if (unitTimeInterval.equals("minute")) {
            if (rowUnit.equals("hour")) {
                // minutes in 1 hour
                for (int i = 0; i < 60; i = i + valueUnitTimeInterval) {
                    String minute = "";
                    if (i < 10) {
                        minute += "0";
                    }
                    minute += "" + i + ":00";
                    listColumnLabels.add(minute);

                }
            } else {
                if (rowUnit.equals("day")) {
                    //minutes in 1 day
                    DateFormat df = new SimpleDateFormat("HH:mm:ss");
                    Calendar cal = Calendar.getInstance();
                    cal.set(Calendar.HOUR_OF_DAY, 0);
                    cal.set(Calendar.MINUTE, 0);
                    cal.set(Calendar.SECOND, 0);
                    int startDate = cal.get(Calendar.DATE);
                    while (cal.get(Calendar.DATE) == startDate) {
                        listColumnLabels.add(df.format(cal.getTime()));
                        cal.add(Calendar.MINUTE, valueUnitTimeInterval);
                    }
                }
            }

        } else {
            if (unitTimeInterval.equals("hour")) {
                //hours in 1 day
                for (int i = 0; i < 24; i = i + valueUnitTimeInterval) {
                    String hour = "";
                    if (i < 10) {
                        hour += "0";
                    }
                    hour += "" + i + ":00:00";
                    listColumnLabels.add(hour);

                }

            } else {
                if (unitTimeInterval.equals("day")) {
                    //days in 1 month
                    for (int i = 1; i <= 31; i = i + valueUnitTimeInterval) {
                        String day = "day ";
                        if (i < 10) {
                            day += "0";
                        }
                        day += "" + i;
                        listColumnLabels.add(day);
                    }
                } else {
                    if (unitTimeInterval.equals("month")) {
                        //months in 1 year
                        for (int i = 1; i <= 12; i = i + valueUnitTimeInterval) {
                            String month = "month ";
                            if (i < 10) {
                                month += "0";
                            }
                            month += "" + i;
                            listColumnLabels.add(month);
                        }
                    }
                }
            }
        }
        return listColumnLabels;
    }

    public static java.util.ArrayList<String> listTimeLabelsByUnitTimeInterval(String timeRangeUnit, Integer initTime, Integer endTime, String unitTimeInterval, Integer valueUnitTimeInterval) {

        java.util.ArrayList<String> listTimeLabels = new java.util.ArrayList<>();

        if (timeRangeUnit.equals(unitTimeInterval)) {
            listTimeLabels = Util.listTimeLabelsWithSameTimeUnit(timeRangeUnit, initTime, endTime, valueUnitTimeInterval);

        } else {
            if (timeRangeUnit.equals("hour") && timeRangeUnit.equals("minute")) {

            } else if (timeRangeUnit.equals("day") && timeRangeUnit.equals("hour")) {

            } else if (timeRangeUnit.equals("day") && timeRangeUnit.equals("minute")) {

            } else if (timeRangeUnit.equals("month") && timeRangeUnit.equals("day")) {

            } else if (timeRangeUnit.equals("month") && timeRangeUnit.equals("hour")) {

            } else if (timeRangeUnit.equals("month") && timeRangeUnit.equals("minute")) {

            } else if (timeRangeUnit.equals("year") && timeRangeUnit.equals("month")) {

            } else if (timeRangeUnit.equals("year") && timeRangeUnit.equals("day")) {

            } else if (timeRangeUnit.equals("year") && timeRangeUnit.equals("hour")) {

            } else if (timeRangeUnit.equals("year") && timeRangeUnit.equals("minute")) {

            }
        }
        return listTimeLabels;
    }

    public static boolean isParsableToInt(String str) {
        try {
            Integer.parseInt(str);
            return true;
        } catch (NumberFormatException nfe) {
            return false;
        }

    }

    public static int convertToInt(String string) {
        return string.toLowerCase().hashCode();
    }

    public static int numberRows(int numberElements, int numberCols) {
        int numberRows = numberElements / numberCols;
        if (numberElements % numberCols > 0) {
            numberRows++;
        }
        return numberRows;
    }

    public static int randomNumber(java.util.ArrayList<Integer> listPreviousNumbers, int maxNumber) {
        int randomNum = (int) (Math.random() * maxNumber);
        int previousNumber = listPreviousNumbers.get(listPreviousNumbers.size() - 1);
        while (listPreviousNumbers.contains(randomNum) || (Math.abs(randomNum - previousNumber) <= 7)) {
            randomNum = (int) (Math.random() * maxNumber);
        }
        return randomNum;
    }

    public static double colorDistance(java.awt.Color c1, java.awt.Color c2) {
        double result = Math.sqrt(Math.pow(c1.getRed() - c2.getRed(), 2)
                + Math.pow(c1.getGreen() - c2.getGreen(), 2)
                + Math.pow(c1.getBlue() - c2.getBlue(), 2)
        );
        return result;
    }

    public static int randomColor(java.util.ArrayList<Integer> listPreviousNumbers, java.awt.Color[] colorMap) {
        int randomNum = (int) (Math.random() * colorMap.length);

        boolean flagSimilar = false;
        int elemNotSimilar = 0;

        while (flagSimilar == true || elemNotSimilar < listPreviousNumbers.size()) {
            elemNotSimilar = 0;
            flagSimilar = false;
            for (Integer listPreviousNumber : listPreviousNumbers) {
                if (Util.colorDistance(colorMap[listPreviousNumber], colorMap[randomNum]) < 100
                        || ((colorMap[randomNum].getBlue() == colorMap[randomNum].getRed())
                        && (colorMap[randomNum].getRed() == colorMap[randomNum].getGreen()))) {
                    flagSimilar = true;
                    break;
                } else {
                    elemNotSimilar++;
                }
            }
            if (flagSimilar == true) {
                randomNum = (int) (Math.random() * colorMap.length);
            }
        }

        return randomNum;
    }

    public static float getLuminance(java.awt.Color color) {
        return (0.2126f * color.getRed()) + (0.7152f * color.getGreen()) + (0.0722f * color.getBlue());
    }

    public static String getColorByLuminance(java.awt.Color color) {
        float y = getLuminance(color);
        return y < 128 ? "#ffffff" : "#000000"; //#ffffff=white, #000000=black
    }

    public static java.util.ArrayList<java.util.ArrayList<Double>> getNormalizedMatrix(java.util.ArrayList<java.util.ArrayList<Double>> originalMatrix, java.util.List<Double> listMaxValues, java.util.List<Double> listMinValues) {

        java.util.ArrayList<java.util.ArrayList<Double>> normalizedMatrix = (java.util.ArrayList<java.util.ArrayList<Double>>) originalMatrix.clone();
        for (int i = 0; i < originalMatrix.size(); i++) {
            for (int j = 0; j < originalMatrix.get(i).size(); j++) {
                Double normalizedValue = Operations.minmax(originalMatrix.get(i).get(j), listMinValues.get(j), listMaxValues.get(j), 0.0, 1.0);
                normalizedMatrix.get(i).set(j, normalizedValue);
            }
        }
        return normalizedMatrix;
    }

    public static void printIntegerVector(int[] input) {
        if (input == null) {
            return; // Or throw an exception - your choice
        }
        System.out.println("Integer Vector");
        for (int input1 : input) {

            System.out.print(input1 + " ");

            System.out.println();
        }
    }

    public static void printFloatVector(float[] input) {
        if (input == null) {
            return; // Or throw an exception - your choice
        }
        System.out.println("Float Vector");
        for (float input1 : input) {

            System.out.print(input1 + " ");

            System.out.println();
        }
    }
     public static void printDoubleVector(double[] input) {
        if (input == null) {
            return; // Or throw an exception - your choice
        }
        System.out.println("Double Vector");
        for (double input1 : input) {

            System.out.print(input1 + " ");

            System.out.println();
        }
    }

    public static void printIntegerMatrix(int[][] input) {
        if (input == null) {
            return; // Or throw an exception - your choice
        }
        System.out.println("Integer Matrix");
        for (int[] input1 : input) {
            for (int j = 0; j < input1.length; j++) {
                System.out.print(input1[j] + " ");
            }
            System.out.println();
        }
    }

    public static void printDoubleMatrix(double[][] input) {
        if (input == null) {
            return; // Or throw an exception - your choice
        }
        System.out.println("Double Matrix");
        for (double[] input1 : input) {
            for (int j = 0; j < input1.length; j++) {
                System.out.print(input1[j] + " ");
            }
            System.out.println();
        }
    }

    public static void printFloatMatrix(float[][] input) {
        if (input == null) {
            return; // Or throw an exception - your choice
        }
        System.out.println("Float Matrix");
        for (float[] input1 : input) {
            for (int j = 0; j < input1.length; j++) {
                System.out.print(input1[j] + " ");
            }
            System.out.println();
        }
    }

    public static double[][] convertFloatMatrixToDoubleMatrix(float[][] input) {
        if (input == null) {
            return null; // Or throw an exception - your choice
        }

        double[][] output = new double[input.length][input[0].length];
        for (int i = 0; i < input.length; i++) {
            for (int j = 0; j < input[i].length; j++) {
                output[i][j] = input[i][j];
            }
        }
        return output;
    }

    public static double[][] calculateCorrelationMatrix(int[] indices, java.util.ArrayList<dataMaker.TimeInterval> listTimeIntervalsData) {
        if (indices == null || listTimeIntervalsData == null) {
            return null; // Or throw an exception - your choice
        }

        double[][] output = new double[indices.length][indices.length];
        for (int i = 0; i < indices.length; i++) {
            for (int j = i; j < indices.length; j++) {
                if (i == j) {
                    output[i][j] = 1.0;
                } else {
                    double valueCorrelation = Operations.pearson(listTimeIntervalsData.get(indices[i]).getMatrix().getMatrix(), listTimeIntervalsData.get(indices[j]).getMatrix().getMatrix());
                    output[j][i] = output[i][j] = valueCorrelation;

                }
            }
        }
        return output;
    }

    public static int[][] calculateColorCorrelationMatrix(java.util.ArrayList<dataMaker.TimeInterval> listTimeIntervalsData, java.util.ArrayList<Integer> listOrderedIds) {
        if (listTimeIntervalsData == null) {
            return null; // Or throw an exception - your choice
        }

        int[][] output = new int[listOrderedIds.size()][listOrderedIds.size()];
        for (int i = 0; i < listOrderedIds.size(); i++) {
            for (int j = i; j < listOrderedIds.size(); j++) {
                if (i == j) {
                    output[i][j] = 255;
                } else {
                    double valueCorrelation = Operations.pearson(listTimeIntervalsData.get(listOrderedIds.get(i)).getMatrix().getMatrix(), listTimeIntervalsData.get(listOrderedIds.get(j)).getMatrix().getMatrix());
                    System.out.println("correlation  "+ valueCorrelation);
                    if (valueCorrelation >= 0) {

                        double valueColor = Operations.minmax(valueCorrelation, 0.0, 1.0, 0.0, 255.0);
                        output[j][i] = output[i][j] = (int) Math.round(valueColor);
                    } else {

                        double valueColor = Operations.minmax(valueCorrelation, -1.0, 0.0, -255.0, 0.0);
                        output[j][i] = output[i][j] = (int) Math.round(valueColor);
                    }

                }
            }
        }
        return output;

    }

    public static int[][] calculateColorCorrelationMatrix(int[] indices, java.util.ArrayList<dataMaker.TimeInterval> listTimeIntervalsData) {
        if (listTimeIntervalsData == null) {
            return null; // Or throw an exception - your choice
        }

        int[][] output = new int[indices.length][indices.length];

        for (int i = 0; i < indices.length; i++) {
            for (int j = i; j < indices.length; j++) {
                if (i == j) {
                    output[i][j] = 255;
                } else {
                    double valueCorrelation = Operations.pearson(listTimeIntervalsData.get(indices[i]).getMatrix().getMatrix(), listTimeIntervalsData.get(indices[j]).getMatrix().getMatrix());
                    if (valueCorrelation >= 0) {

                        double valueColor = Operations.minmax(valueCorrelation, 0.0, 1.0, 0.0, 255.0);
                        output[j][i] = output[i][j] = (int) valueColor;
                    } else {
                        double valueColor = Operations.minmax(valueCorrelation, -1.0, 0.0, 0.0, 255.0);
                        output[j][i] = output[i][j] = (int) (valueColor - 255);
                    }

                }
            }
        }
        return output;

    }

    public static double log(double x, double base) {
        return (Math.log(x) / Math.log(base));
    }

    public static double perplexity(java.util.ArrayList<java.util.ArrayList<Integer>> resultClustering, int numberInstances) {
        double perplexity = 0.0;
        double hP = 0.0;

        for (ArrayList<Integer> resultClustering1 : resultClustering) {
            double pi = resultClustering1.size() / numberInstances;
            hP += (pi * log(pi, 2));
        }

        perplexity = Math.pow(2, hP);
        return perplexity;
    }

    public static ArrayList<ArrayList<Integer>> removeIntegerArrayListMatrix(int index, ArrayList<ArrayList<Integer>> z) {
        if (index > z.size()) {
            return z;
        } else {
            ArrayList<ArrayList<Integer>> returnThis = new ArrayList<>();
            int newIndex = 0;
            for (int i = 0; i < z.size(); i++) {
                if (i != index) {
                    returnThis.add(z.get(i));
                    //returnThis[newIndex] = z[i];
                    newIndex++;
                }
            }
            return returnThis;
        }
    }

    public static int[] removeIntegerArray(int index, int[] z) {
        if (index > z.length) {
            return z;
        } else {
            int[] returnThis = new int[z.length - 1];
            int newIndex = 0;
            for (int i = 0; i < z.length; i++) {
                if (i != index) {
                    returnThis[newIndex] = z[i];
                    newIndex++;
                }
            }
            return returnThis;
        }
    }

    public static <T> boolean contains(final T[] array, final T v) {
        for (final T e : array) {
            if (e == v || v != null && v.equals(e)) {
                return true;
            }
        }

        return false;
    }

    public static boolean contains(final int[] array, final int v) {
        for (final int e : array) {
            if (e == v) {
                return true;
            }
        }

        return false;
    }

    public static Object resizeArray(Object oldArray, int newSize) {
        int oldSize = java.lang.reflect.Array.getLength(oldArray);
        Class elementType = oldArray.getClass().getComponentType();
        Object newArray = java.lang.reflect.Array.newInstance(
                elementType, newSize);
        int preserveLength = Math.min(oldSize, newSize);
        if (preserveLength > 0) {
            System.arraycopy(oldArray, 0, newArray, 0, preserveLength);
        }
        return newArray;
    }

    public static int getRowLabelIndex(ArrayList<String> listRowLabels, String searchedLabel, String rowUnit) {
        int index = 0;
        if (rowUnit.equals("minute")) {
            //search hour
            String[] splittedTime = searchedLabel.split(" ");
            String[] splittedDay = splittedTime[1].split(":");
            String searchedFilteredLabel = searchedLabel;

            index = listRowLabels.indexOf(searchedFilteredLabel);
        } else {
            if (rowUnit.equals("hour")) {
                //search day
                String[] splittedTime = searchedLabel.split(" ");
                String[] splittedDay = splittedTime[1].split(":");
                String searchedFilteredLabel = splittedTime[0] + " " + splittedDay[0] + ":" + splittedDay[1] + ":00";

                index = listRowLabels.indexOf(searchedFilteredLabel);
            } else {
                if (rowUnit.equals("day")) {
                    //search month
                    String[] splittedTime = searchedLabel.split(" ");

                    String searchedFilteredLabel = splittedTime[0];

                    index = listRowLabels.indexOf(searchedFilteredLabel);
                } else {
                    if (rowUnit.equals("month")) {
                        //search day
                        String[] splittedTime = searchedLabel.split(" ");
                        String[] splittedDay = splittedTime[0].split("-");
                        String searchedFilteredLabel = splittedDay[0] + "-" + splittedDay[1];

                        index = listRowLabels.indexOf(searchedFilteredLabel);
                    } else {
                        if (rowUnit.equals("year")) {
                            //search day
                            String[] splittedTime = searchedLabel.split(" ");
                            String[] splittedDay = splittedTime[0].split("-");
                            String searchedFilteredLabel = splittedDay[0];

                            index = listRowLabels.indexOf(searchedFilteredLabel);
                        }
                    }
                }
            }
        }
        return index;
    }

    public static int getColumnLabelIndex(ArrayList<String> listColumnLabels, String searchedLabel, String timeUnit, String rowUnit) {
        int index = 0;
        if (timeUnit.equals("minute")) {
            //search hour
            String[] splittedTime = searchedLabel.split(" ");
            String[] splittedDay = splittedTime[0].split("-");
            String[] splittedMinute = splittedTime[1].split(":");
            String searchedFilteredLabel = "";
            if (rowUnit.equals("day")) {
                searchedFilteredLabel += splittedMinute[0] + ":";
            } else {
                if (rowUnit.equals("month")) {
                    searchedFilteredLabel += splittedDay[2] + " " + splittedMinute[0] + ":";
                } else {
                    if (rowUnit.equals("year")) {
                        searchedFilteredLabel += splittedDay[1] + "-" + splittedDay[2] + " " + splittedMinute[0] + ":";
                    }
                }
            }
            searchedFilteredLabel += splittedMinute[1] + ":" + splittedMinute[2];

            index = listColumnLabels.indexOf(searchedFilteredLabel);
        } else {
            if (timeUnit.equals("hour")) {
                //search hour
                String[] splittedTime = searchedLabel.split(" ");
                String[] splittedDay = splittedTime[0].split("-");
                String[] splittedMinute = splittedTime[1].split(":");
                String searchedFilteredLabel = "";
                if (rowUnit.equals("month")) {
                    searchedFilteredLabel += splittedDay[2] + " " + splittedMinute[0] + ":";
                } else {
                    if (rowUnit.equals("year")) {
                        searchedFilteredLabel += splittedDay[1] + "-" + splittedDay[2] + " " + splittedMinute[0] + ":";
                    }
                }
                searchedFilteredLabel += splittedTime[1];
                index = listColumnLabels.indexOf(searchedFilteredLabel);
            } else {
                if (timeUnit.equals("day")) {
                    //search day
                    String[] splittedTime = searchedLabel.split(" ");
                    String[] splittedDay = splittedTime[0].split("-");
                    String searchedFilteredLabel = "day " + splittedDay[2];

                    index = listColumnLabels.indexOf(searchedFilteredLabel);
                } else {
                    if (timeUnit.equals("month")) {
                        //search month
                        String[] splittedTime = searchedLabel.split(" ");
                        String[] splittedDay = splittedTime[0].split("-");
                        String searchedFilteredLabel = "month " + splittedDay[1];

                        index = listColumnLabels.indexOf(searchedFilteredLabel);
                    }
                }
            }
        }
        return index;
    }

    public static String replaceStringOperators(String description) {

        return description.replace("lessequal", "<=").replace("greaterequal", ">=").replace("less", "<").replace("greater", ">").replace("equal", "=");

    }

    public static int[] convertArrayListToArray(ArrayList<Integer> integers) {
        int[] ret = new int[integers.size()];
        for (int i = 0; i < ret.length; i++) {
            ret[i] = integers.get(i);
        }
        return ret;
    }

    public static double round(double value, int places) {
        try {
            if (places < 0) {
                throw new IllegalArgumentException();
            }

            BigDecimal bd = new BigDecimal(value);
            bd = bd.setScale(places, RoundingMode.HALF_UP);
            return bd.doubleValue();
        } catch (Exception e) {
            return Double.NaN;
        }
    }

    public static int calculateMaxHaarLevel(int number) {
        int num2 = 0;

        if (number == 1) {
            return 0;
        }
        while (Math.pow(2, num2 + 1) <= number) {
            num2++;
        }

        return (num2);
    }

    public static void writeMatrixToFile(String filename, double[][] matrix) throws IOException {
        BufferedWriter outputWriter = null;
        String entirePath = "/home/aurea/";
        outputWriter = new BufferedWriter(new FileWriter(entirePath + filename));
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {

                outputWriter.write(matrix[i][j] + " ");
            }
            outputWriter.newLine();

        }
        outputWriter.flush();
        outputWriter.close();
    }

    public static ArrayList<Integer> getRepresentativesByLinearRegression(ArrayList<TimeInterval> listTimeIntervals,
            int targetId) {
        ArrayList<ArrayList<Double>> matrixValues = new ArrayList<ArrayList<Double>>();
        ArrayList<String> listRegressionClasses = new ArrayList<String>();
        int numberCols_r = 0;
        int numberRows_r = 0;
        int vectorSize_r = 0;

        numberRows_r = listTimeIntervals.get(0).getMatrix().getRows();
        numberCols_r = listTimeIntervals.get(0).getMatrix().getCols();
        vectorSize_r = listTimeIntervals.size();

        for (int countRows = 0; countRows < numberRows_r; countRows++) {
            for (int countCols = 0; countCols < numberCols_r; countCols++) {
                ArrayList<Double> rowValues = new ArrayList<Double>();
                boolean nanBool = false;

                for (int count = 0; count < listTimeIntervals.size(); count++) {
                    if (count != targetId) {
                        Double value = listTimeIntervals.get(count).getMatrix().getOriginalValue(countRows, countCols);
                        if (!value.isNaN()) {
                            rowValues.add(value);
                        } else {
                            nanBool = true;
                            rowValues.add(Double.MIN_VALUE);
                        }
                    }

                }

                Double categorizationValue = listTimeIntervals.get(targetId).getMatrix().getOriginalValue(countRows, countCols);

                if (categorizationValue.isNaN()) {
                    nanBool = true;
                }

                if (nanBool == false) {

                    Double categorizationValueDouble = Util.round(categorizationValue, 2);
                    Float categorizationValueFloat = Float.valueOf(categorizationValueDouble.toString());
                    listRegressionClasses.add(categorizationValueDouble.toString());
                    matrixValues.add(rowValues);

                }

            }
        }

        Instances regressionDataInstances = null;
        int numberRegressionAttributes = listTimeIntervals.size();

        ArrayList<Integer> listIdAttributes = new ArrayList<Integer>();
        FastVector fvRegressionAttributes = new FastVector(numberRegressionAttributes);
        for (int i = 0; i < listTimeIntervals.size(); i++) {
            if (i != targetId) {
                String attributeName = i + "_" + listTimeIntervals.get(i).getNameAttribute();
                listIdAttributes.add(i);
                Attribute wekaAttribute = new Attribute(attributeName, i);
                fvRegressionAttributes.addElement(wekaAttribute);
            }
        }

        Attribute regressionClassAttribute = new Attribute("classRegression");
        fvRegressionAttributes.addElement(regressionClassAttribute);
        regressionDataInstances = new Instances("Rel", fvRegressionAttributes, matrixValues.size());
        for (int i = 0; i < matrixValues.size(); i++) {

            // Create the instance
            int instanceSize = matrixValues.get(i).size() + 1;
            Instance iExample = new Instance(instanceSize);
            int j = 0;
            for (j = 0; j < matrixValues.get(i).size(); j++) {

                iExample.setValue((Attribute) fvRegressionAttributes.elementAt(j), matrixValues.get(i).get(j));
            }

            iExample.setValue((Attribute) fvRegressionAttributes.elementAt(j), Double.valueOf(listRegressionClasses.get(i)));
            // add the instance
            regressionDataInstances.add(iExample);
        }
        double[] coeffs = null;//linear regression

        LinearRegressionRegression typeClassifier = null;
        //linear regression
        typeClassifier = null;
        typeClassifier = new LinearRegressionRegression();
        coeffs = typeClassifier.classifyGetCoeff(regressionDataInstances);

        ArrayList<Integer> listRepresentatives = new ArrayList<Integer>();

        for (int j = 0; j < listIdAttributes.size(); j++) {
            if (coeffs[j] != 0.0 && listRepresentatives.indexOf(listIdAttributes.get(j)) == -1) {
                  listRepresentatives.add(listIdAttributes.get(j));
            }
        }
      

        return listRepresentatives;

    }
    
    public static ArrayList<Integer> getRepresentativesBySimpleRegression(ArrayList<TimeInterval> listTimeIntervals,
            int targetId) {
        ArrayList<ArrayList<Double>> matrixValues = new ArrayList<ArrayList<Double>>();
        ArrayList<String> listRegressionClasses = new ArrayList<String>();
        int numberCols_r = 0;
        int numberRows_r = 0;
        int vectorSize_r = 0;

        numberRows_r = listTimeIntervals.get(0).getMatrix().getRows();
        numberCols_r = listTimeIntervals.get(0).getMatrix().getCols();
        vectorSize_r = listTimeIntervals.size();

        for (int countRows = 0; countRows < numberRows_r; countRows++) {
            for (int countCols = 0; countCols < numberCols_r; countCols++) {
                ArrayList<Double> rowValues = new ArrayList<Double>();
                boolean nanBool = false;

                for (int count = 0; count < listTimeIntervals.size(); count++) {
                    if (count != targetId) {
                        Double value = listTimeIntervals.get(count).getMatrix().getOriginalValue(countRows, countCols);
                        if (!value.isNaN()) {
                            rowValues.add(value);
                        } else {
                            nanBool = true;
                            rowValues.add(Double.MIN_VALUE);
                        }
                    }

                }

                Double categorizationValue = listTimeIntervals.get(targetId).getMatrix().getOriginalValue(countRows, countCols);

                if (categorizationValue.isNaN()) {
                    nanBool = true;
                }

                if (nanBool == false) {

                    Double categorizationValueDouble = Util.round(categorizationValue, 2);
                    Float categorizationValueFloat = Float.valueOf(categorizationValueDouble.toString());
                    listRegressionClasses.add(categorizationValueDouble.toString());
                    matrixValues.add(rowValues);

                }

            }
        }

        Instances regressionDataInstances = null;
        int numberRegressionAttributes = listTimeIntervals.size();

        ArrayList<Integer> listIdAttributes = new ArrayList<Integer>();
        FastVector fvRegressionAttributes = new FastVector(numberRegressionAttributes);
        for (int i = 0; i < listTimeIntervals.size(); i++) {
            if (i != targetId) {
                String attributeName = i + "_" + listTimeIntervals.get(i).getNameAttribute();
                listIdAttributes.add(i);
                Attribute wekaAttribute = new Attribute(attributeName, i);
                fvRegressionAttributes.addElement(wekaAttribute);
            }
        }

        Attribute regressionClassAttribute = new Attribute("classRegression");
        fvRegressionAttributes.addElement(regressionClassAttribute);
        regressionDataInstances = new Instances("Rel", fvRegressionAttributes, matrixValues.size());
        for (int i = 0; i < matrixValues.size(); i++) {

            // Create the instance
            int instanceSize = matrixValues.get(i).size() + 1;
            Instance iExample = new Instance(instanceSize);
            int j = 0;
            for (j = 0; j < matrixValues.get(i).size(); j++) {

                iExample.setValue((Attribute) fvRegressionAttributes.elementAt(j), matrixValues.get(i).get(j));
            }

            iExample.setValue((Attribute) fvRegressionAttributes.elementAt(j), Double.valueOf(listRegressionClasses.get(i)));
            // add the instance
            regressionDataInstances.add(iExample);
        }
        int index = -1;
        SimpleLinearRegressionRegression typeClassifier = null;
        //linear regression
        typeClassifier = null;
        typeClassifier = new SimpleLinearRegressionRegression();
        index = typeClassifier.classifyGetIndex(regressionDataInstances);

        ArrayList<Integer> listRepresentatives = new ArrayList<Integer>();

        if(index!=-1 && listRepresentatives.indexOf(listIdAttributes.get(index)) == -1){
            listRepresentatives.add(listIdAttributes.get(index));
        }
        

        return listRepresentatives;

    }

    public static ArrayList<Integer> getMedoids(Clustering clustering, AbstractMatrix matrix, int numberMedoids, AbstractDissimilarity diss) {

        ArrayList<Integer> m = new ArrayList<Integer>();

        for (int i = 0; i < clustering.getListClusters().size(); i++) {

            for (int k = 0; k < numberMedoids && k < clustering.getListClusters().get(i).size(); k++) {
                int point = -1;
                float distance = Float.MAX_VALUE;
                for (int j = 0; j < clustering.getListClusters().get(i).size(); j++) {
                    int id = clustering.getListClusters().get(i).get(j);
                    float distance2 = diss.calculate(clustering.getCentroids().getRow(i),
                            matrix.getRow(id));
                    if ((distance > distance2) && m.indexOf(id) == -1) {
                        point = id;
                        distance = distance2;
                    }
                }
                if (point != -1) {
                    m.add(point);
                }
            }
        }

        return m;

    }

    public static void main(String[] args) {

       int nameAttribute = "offenders_au".compareTo("oof");
       System.out.println(nameAttribute);
    }
}
