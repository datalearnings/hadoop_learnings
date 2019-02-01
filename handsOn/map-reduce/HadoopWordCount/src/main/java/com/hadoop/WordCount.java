package com.hadoop;

import java.io.IOException;
import java.util.*;

import org.apache.hadoop.conf.*;
import org.apache.hadoop.fs.*;
import org.apache.hadoop.conf.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.input.*;
import org.apache.hadoop.mapreduce.lib.output.*;
import org.apache.hadoop.util.*;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;

import java.io.IOException;

public class WordCount extends Configured implements Tool {

// inp : <12312313,the><12333423424,hadoop><66456456,the>
//  out : <the,1> <hadoop,1><the,1>
   static public class WordCountMapper extends Mapper<LongWritable, Text, Text, LongWritable> {
      final private static LongWritable ONE = new LongWritable(1);
      private Text tokenValue = new Text();

      @Override
      protected void map(LongWritable offset, Text text, Context context) throws IOException, InterruptedException {
         for (String token : text.toString().split("\\s+")) {
            tokenValue.set(token);
            context.write(tokenValue, ONE);
         }
      }
   }

   //  in : <the,1> <hadoop,1><the,1>
   //out :  <the,2> <hadoop,1>

   static public class WordCountReducer extends Reducer<Text, LongWritable, Text, LongWritable> {
      private LongWritable total = new LongWritable();

      @Override
      protected void reduce(Text token, Iterable<LongWritable> counts, Context context)
            throws IOException, InterruptedException {
         long n = 0;
         for (LongWritable count : counts)
            n += count.get();
         total.set(n);
         context.write(token, total);
      }
   }

   public int run(String[] args) throws Exception {
      Configuration configuration = getConf();

      Path inputPath = new Path(args[0]);
      Path outputPath = new Path(args[1]);


      Job job = new Job(configuration, "Word Count");
      job.setJarByClass(WordCount.class);

      FileInputFormat.setInputPaths(job, inputPath);
      FileOutputFormat.setOutputPath(job, outputPath);

      job.setMapperClass(WordCountMapper.class);
      job.setCombinerClass(WordCountReducer.class);
      job.setReducerClass(WordCountReducer.class);

      job.setInputFormatClass(TextInputFormat.class);
      job.setOutputFormatClass(TextOutputFormat.class);

      job.setOutputKeyClass(Text.class); // wprds <the ,2>
      job.setOutputValueClass(LongWritable.class); // count of the words

      return job.waitForCompletion(true) ? 0 : -1;
   }

   public static void main(String[] args) throws Exception {
      System.exit(ToolRunner.run(new WordCount(), args));
   }
}
