// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

namespace py impala._thrift_gen.ExecStats
namespace cpp impala
namespace java org.apache.impala.thrift

include "Status.thrift"
include "Types.thrift"

enum TExecState {
  REGISTERED = 0,
  PLANNING = 1,
  QUEUED = 2,
  RUNNING = 3,
  FINISHED = 4,

  CANCELLED = 5,
  FAILED = 6,
}

// Execution stats for a single plan node.
struct TExecStats {
  // The wall clock time spent on the "main" thread. This is the user perceived
  // latency. This value indicates the current bottleneck.
  // Note: anywhere we have a queue between operators, this time can fluctuate
  // significantly without the overall query time changing much (i.e. the bottleneck
  // moved to another operator). This is unavoidable though.
  1: optional i64 latency_ns

  // Total CPU time spent across all threads. For operators that have an async
  // component (e.g. multi-threaded) this will be >= latency_ns.
  // TODO-MT: remove this or latency_ns
  2: optional i64 cpu_time_ns

  // Number of rows returned.
  3: optional i64 cardinality

  // Peak memory used (in bytes).
  4: optional i64 memory_used
}

// Summary for a single plan node or data sink. This includes labels for how to display
// the node as well as per instance stats.
struct TPlanNodeExecSummary {
  // The plan node ID or -1 if this is a data sink at the root of a fragment.
  1: required Types.TPlanNodeId node_id
  2: required Types.TFragmentIdx fragment_idx
  3: required string label
  4: optional string label_detail
  5: required i32 num_children

  // Estimated stats generated by the planner
  6: optional TExecStats estimated_stats

  // One entry for each fragment instance executing this plan node or data sink.
  7: optional list<TExecStats> exec_stats

  // If true, this is an exchange node that is the receiver of a broadcast.
  8: optional bool is_broadcast
}

// Progress counters for an in-flight query.
struct TExecProgress {
  1: optional i64 total_scan_ranges
  2: optional i64 num_completed_scan_ranges
}

// Execution summary of an entire query.
struct TExecSummary {
  // State of the query.
  1: required TExecState state

  // Contains the error if state is FAILED.
  2: optional Status.TStatus status

  // Flattened execution summary of the plan tree.
  3: optional list<TPlanNodeExecSummary> nodes

  // For each exch node in 'nodes', contains the index to the root node of the sending
  // fragment for this exch. Both the key and value are indices into 'nodes'.
  4: optional map<i32, i32> exch_to_sender_map

  // List of errors that were encountered during execution. This can be non-empty
  // even if status is okay, in which case it contains errors that impala skipped
  // over.
  5: optional list<string> error_logs

  // Optional record indicating the query progress
  6: optional TExecProgress progress

  // Set to true if the query is currently queued by admission control.
  7: optional bool is_queued

  // Contains the latest queuing reason if the query is currently queued by admission
  // control.
  8: optional string queued_reason
}
