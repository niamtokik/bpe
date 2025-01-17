-ifndef(BPE_HRL).
-define(BPE_HRL, true).

-include_lib("kvs/include/cursors.hrl").

-define(DEFAULT_MODULE, application:get_env(bpe,default_module,bpe_xml)).

-define(TASK,           id=[] :: list(),
                        name=[] :: list() | binary(),
                        input=[] :: list(),
                        output=[] :: list(),
                        prompt=[] :: list(tuple()),
                        roles=[] :: list(atom()),
                        etc=[] :: list({term(),term()}) ).

-define(EVENT,          id=[] :: list() | atom(),
                        name=[] :: list() | binary(),
                        prompt=[] :: list(tuple()),
                        etc=[] :: list({term(),term()}),
                        payload=[] :: [] | binary(),
                        timeout=[] :: [] | #timeout{} ).

-define(CYCLIC,         timeDate=[] :: [] | binary(),
                        timeDuration=[] :: [] | binary(),
                        timeCycle=[] :: [] | binary() ).

-record(timeout,      { spec= [] :: term() }).

-type condition() :: {compare,BpeDocParam :: {atom(),term()},Field :: integer(), ConstCheckAgainst :: term()}
                   | {service,atom(),atom()}
                   | {service,atom()}.

-record(sequenceFlow, { id=[] :: list(),
                        name=[] :: list() | binary(),
                        condition=[] :: [] | condition() | binary(),
                        source=[] :: list(),
                        target=[] :: list(integer()) | list(list()) }).

-record(beginEvent ,  { ?TASK }).
-record(endEvent,     { ?TASK }).
-record(task,         { ?TASK }).
-record(userTask,     { ?TASK }).
-record(serviceTask,  { ?TASK }).
-record(receiveTask,  { ?TASK, reader=[] :: #reader{} }).
-record(sendTask,     { ?TASK, writer=[] :: #writer{} }).
-record(gateway,      { ?TASK, type= parallel :: gate(), def=[] :: list() }).
-record(messageEvent, { ?EVENT }).
-record(messageBeginEvent, { ?EVENT }).
-record(boundaryEvent,{ ?EVENT, ?CYCLIC }).
-record(timeoutEvent, { ?EVENT, ?CYCLIC }).

-type tasks()  :: #task{} | #serviceTask{} | #userTask{} | #receiveTask{} | #sendTask{} | #beginEvent{} | #endEvent{}.
-type events() :: #messageEvent{} | #boundaryEvent{} | #timeoutEvent{}.
-type procId() :: [] | string() | integer() | {atom(),any()}.
-type gate()   :: exclusive | parallel | inclusive | complex | event.

-record(ts,    { time= [] :: term() }).
-record(step,  { id = 0 :: integer(), proc = "" :: list() }).
-record(role,  { id = [] :: list(), name :: binary(), tasks = [] :: term() }).
-record(sched, { id = [] :: [] | #step{},
                 prev=[] :: [] | integer(),
                 next=[] :: [] | integer(),
                 pointer = -1 :: integer(),
                 state = [] :: list(list()) }).

-record(hist,         { id = [] :: [] | #step{},
                        prev=[] :: [] | integer(),
                        next=[] :: [] | integer(),
                        name=[] :: [] | binary() | list(),
                        task=[] :: [] | atom() | list() | #task{} | #sequenceFlow{} | condition(),
                        docs=[] :: list(tuple()),
                        time=[] :: [] | #ts{} }).

-record(process,      { id         = [] :: procId(),
                        prev       = [] :: [] | integer(),
                        next       = [] :: [] | integer(),
                        name       = [] :: [] | binary() | string() | atom(),
                        desc       = [] :: list() | binary(),
                        vsn        = [] :: term(),
                        feeds      = [] :: list(),
                        module     = [] :: [] | atom(),
                        roles      = [] :: term(),
                        tasks      = [] :: list(tasks()),
                        events     = [] :: list(events()),
                        flows      = [] :: list(#sequenceFlow{}),
                        docs       = [] :: list(tuple()),
                        options    = [] :: term(),
                        xml        = [] :: list(),
                        svg        = [] :: list(),
                        timer      = [] :: [] | reference(),
                        notifications=[] :: [] | term(),
                        result     = [] :: [] | binary(),
                        started    = [] :: [] | #ts{},
                        modified   = [] :: [] | #ts{},
                        finished   = [] :: [] | #ts{},
                        monitor    = [] :: [] | integer(),
                        parent     = [] :: [] | procId(),
                        children   = [] :: list(procId()),
                        beginEvent = [] :: list() | atom(),
                        endEvent   = [] :: list() | atom(),
                        status     = [] :: term(), % future reserved
                        current    = [] :: term(),
                        rules      = [] :: term(),
                        userStarted  = [] :: term(),
                        userModified = [] :: term(),
                        userFinished = [] :: term(),
                        params     = [] :: term(),
                        filters    = [] :: term(),
                        etc        = [] :: term(),
                        flags      = [] :: term()
                         }).

-record(subProcess,   { name=[] :: [] | atom(),
                        diagram= #process{} :: #process{} }).

-record(procRec,      { id = [] :: procId(),
                        name = [] :: list(),
                        roles = [] :: list(atom()),
                        etc = [] :: term() }).

-record(monitor,  {     id = [] :: procId(),
                        prev=[] :: [] | integer(),
                        next=[] :: [] | integer(),
                        name = [] :: list(),
                        roles = [] :: list(#role{}),
                        ogrName = [] :: list(),
                        status = [] :: term() }).

-record('Next', { id=[]   :: [] | binary() }).
-record('Proc', { id=[]   :: [] | binary() }).
-record('Load', { id=[]   :: [] | binary() }).
-record('Hist', { id=[]   :: [] | binary() }).
-record('Make', { proc=[] :: [] | #process{} | binary(), docs=[] :: [] | list(tuple()) }).
-record('Amen', { id=[]   :: [] | binary(), docs=[] :: [] | list(tuple()) }).

-endif.
