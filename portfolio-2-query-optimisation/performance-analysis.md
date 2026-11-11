\# NovaBank Digital Banking System

\## Portfolio 2: Query Performance Analysis



\### 1. Objective



This exercise evaluates the performance of three PostgreSQL queries before and after indexing. The NovaBank database contained 100,003 transfers, providing sufficient test data to compare query execution plans.



The queries were analysed using `EXPLAIN (ANALYZE, BUFFERS)` to measure execution time, examine scan methods and assess database buffer usage.



\### 2. Performance Comparison



| Query | Before | After | Reduction |

|---|---:|---:|---:|

| Query 1: Completed transfers by date | 18.016 ms | 0.124 ms | 99.31% |

| Query 2: Incoming transfers by account | 5.746 ms | 0.905 ms | 84.25% |

| Query 3: Completed transfers by amount | 22.898 ms | 12.362 ms | 46.01% |



\### 3. Query Analysis



\*\*Query 1: Completed Transfers by Date\*\*



Index: `ix\_transfers\_status\_created`



Before optimisation, PostgreSQL used a parallel sequential scan followed by sorting to retrieve the latest 50 completed transfers. The execution time was 18.016 ms.



After indexing, PostgreSQL used an index scan, reducing execution time to 0.124 ms. The index supported filtering by status and retrieving records in date order without an additional sorting operation.



The measured execution time decreased by \*\*99.31%\*\*.



\*\*Query 2: Incoming Transfers by Account\*\*



Index: `ix\_transfers\_destination\_created`



Before optimisation, PostgreSQL performed a sequential scan, filtering 100,003 transfers to identify 10 matching records. Execution time was 5.746 ms.



After indexing, PostgreSQL used a bitmap index scan and bitmap heap scan to locate the matching transfers, followed by a small sorting operation. Execution time decreased to 0.905 ms.



The measured execution time decreased by \*\*84.25%\*\*.



\*\*Query 3: Completed Transfers by Amount\*\*



Index: `ix\_transfers\_status\_amount`



Before optimisation, PostgreSQL used a sequential scan to identify completed transfers between ₦50,000 and ₦70,000. The execution time was 22.898 ms.



After indexing, PostgreSQL used a bitmap index scan and bitmap heap scan to retrieve 16,173 matching records. Execution time decreased to 12.362 ms.



The measured execution time decreased by \*\*46.01%\*\*.



The improvement was smaller than for the other queries because Query 3 returned a relatively large number of records, requiring additional data-page access.



\### 4. Conclusion



All three queries recorded lower execution times after indexing.



Query 1 achieved the largest improvement at 99.31%, followed by Query 2 at 84.25% and Query 3 at 46.01%.



The results demonstrate that appropriate indexes can reduce unnecessary table scanning and improve query performance. However, the benefit depends on the query conditions, number of matching records and execution plan selected by PostgreSQL.



These results are based on individual test executions, so timings may vary due to caching and system workload.

