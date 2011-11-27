module Patterns
  PREAMBLE = %r{
    \[<a\s+(?:[\w-]+=["'].*?["']\s+)*
        href=["']https?://(.+?\.)?agilezen\.com/project/(?<project_id>\d+?)/board/?["']
        (?:\s+[\w-]+=["'].*?["'])*\s*>\s*
      (?<project_name>.+?)\s*
    </a>\]\s*
    <em>\s*(?<story_snippet>.+?)\s*</em>\s*
    \(<a\s+(?:[\w-]+=["'].*?["']\s+)*
        href=["']https?://(.+?\.)?agilezen\.com/project/\d+?/story/(?<story_id>\d+?)/?["']
        (?:\s+[\w-]+=["'].*?["'])*\s*>.+?</a>\)\s*}xi

  BY = %r{ by \s*<strong>\s* (?<actor>.+?) \s*</strong> }xi

  FROM = %r{ from \s*<strong>\s* (?<from>.+?) \s*</strong> }xi


  PATTERNS = {
    moved: %r{ was \s+ moved \s+ #{FROM} \s* to \s*<strong>\s* (?<to>.+?) \s*</strong> \s+ #{BY} \s* }xi,
    started: %r{ has \s+ started \s* }x,
    created: %r{ was \s+ created \s+ #{BY} \s* }xi,
    blocked: %r{ was \s+ blocked \s+ #{BY}: \s+ <em>\s* (?<reason>.+?) \s*</em>\s* }xi,
    unblocked: %r{ has \s+ been \s+ unblocked \s+ #{BY} \s* }xi,
    ready_to_pull: %r{ was \s+ marked \s+ ready \s+ to \s+ pull \s+ #{FROM} \s* #{BY} \s* }xi,
    not_ready_to_pull: %r{
      was \s+ marked \s*<strong>\s*NOT\s*</strong>\s*
      ready \s+ to \s+ pull \s+ #{FROM} \s* #{BY} \s* }xi,
    new_comment: %r{
      has \s+ a \s+ new \s+ comment \s+
      from \s*<strong>\s* (?<actor>.+?) \s*</strong>:
      \s*<em>\s* (?<text>.+?) \s*</em>\s* }xi,
    finished: %r{
      is \s+ finished: \s*
      (?> (?:
        lead \s+ time \s*<em>\s* (?<lead_time>.+?) \s*</em> |
        cycle \s+ time \s*<em>\s* (?<cycle_time>.+?) \s*</em> |
        work \s+ time \s*<em>\s* (?<work_time>.+?) \s*</em> |
        wait \s+ time \s*<em>\s* (?<wait_time>.+?) \s*</em> |
        blocked \s+ time \s*<em>\s* (?<blocked_time>.+?) \s*</em> |
        efficiency \s*<em>\s* (?<efficiency>.+?) \s*</em>\s*
      ),? \s* )+ }xi,
    reassigned: %r{
      was \s+ reassigned \s+
      #{FROM} \s* to \s*<strong>\s* (?<to>.+?) \s*</strong> \s+ #{BY.source} \s* }xi,
    claimed: %r{ was \s+ claimed \s* #{BY} \s* }xi
  }

  PATTERNS.each_pair do |name, pattern|
    PATTERNS[name] = Regexp.new(['\A', PREAMBLE, pattern, '.?\Z'].join)
  end
end
