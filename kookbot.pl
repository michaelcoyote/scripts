#!/usr/bin/perl -w

# Uses a simple context-free grammar to simulate the ravings of an
# Internet kook.

# Since somebody asked, this code is public domain.  This means you
# can do whatever you like with it, including modify it and release it
# under a different license.  I mean, look, it's so simple, who cares
# what you do with it?

# Of course, the release of this code into the public domain does not
# imply that you can use my name, or the name of any of the
# organizations with which I am affiliated, to promote any product
# that incorporates this code.  Etc., etc., etc.
# ...
# (You should pretend that this space is filled with numerous other
# legal disclaimers that you wouldn't read anyway.)
# ...

# TODO-IDEAS:

# 1. Add markov-model sentence transitions for added inter-sentence
# (in)coherence.

# 2. Do a real, deeper CFG, so that you can get larger coherent
# structures.  The Right Thing is probably to have some productions
# parameterized by words used in enclosing blocks, so that you even
# get the appearance of context-sensitivity.

if (!scalar(@ARGV)) {
  die "Usage: kookbot.pl [number of sentences]\n";
}
my $sentences = shift(@ARGV);

##################################################
# DATA

# Stuff we do like
my @good_adjectives =
  (
   'intelligent',
   'open-minded',
   'honest',
   'clear',
   'practical',
   'flexible yet critical',
   'harmonious',
   'truthful',
   'well-constructed',
  );
my @good_nouns =
  (
   'freedom',
   'justice',
   'straightforwardness',
   'subtlety',
   'strength',
   'compassion',
   'fairness',
   'rational approach',
   'democracy',
   'realism',
  );

# Stuff we don't like
my @bad_adjectives =
  (
   'orthodox',
   'malignant',
   'malevolent',
   'dangerous',
   'fascist',
   'foolish',
   'closed-minded',
   'annoying',
   'unjust',
   'long-winded',
   'lacking in support',
   'shameful',
  );
my @bad_nouns =
  (
   'oppression',
   'tyranny',
   'stupidity',
   'ignorance',
   'discrimination',
   'indifference',
   'propaganda',
   'prejudice',
  );

# Rhetorical tactics: must take an object.
my @tactics_agree =
  (
   'apply principles of',
   'embrace',
   'think along the same lines as',
   'commune with the spirit of',
   'would prefer',
   'argue strenuously for',
   'try to posit',
   'show the validity in',
   );
my @tactics_object =
  (
   'object to',
   'reject anything involved with',
   'refuse to accept',
   'do not agree with',
   'argue strenuously against',
   'disagree with completely',
   'rebut',
   );

# OK, so here's the key:
#  \0 = good_adjective
#  \1 = good_noun
#  \2 = bad_adjective
#  \3 = bad_noun
#  \4 = tactics_agree
#  \5 = tactics_object
my @productions =
  (
   'You \4 the \2 \3 to \1. ',
   'True \0 \1 proceeds from examining \1, not \3. ',
   'One must consider \1 versus \3. ',
   'I can only imagine that you \4 \3. ',
   'You \4 \2 \3.  I \5 that. ',
   'The argument you \4 would result in \3. ',
   'Think about the \3, \2 and \2, and how it compares with \0 \1. ',
   'I ask you to be \0, not \2.  You \5 any appearance of \1. ',
   'Is this \0?  I think it is obvious that your statement is \2 and \2. ',
   'But there is a \0 \1, and your argument would \5 it. ',
   'Can there be any doubt?  I \4 \0, \0 \1, and you obviously do not. ',
   'You \5 the fact that your evidence is shallow, the result of \2 propaganda and \3. ',
   'Yet your argument tries to \5 everything that is \0. ',
   'It is only the \0 evidence that you \5, and it is because you \5 \1. ',
   'I \5 your arguments only.  There is no personal attack here. ',
  );

##################################################
# MAIN

srand;

my $output = '';

for(my $i=0; $i<$sentences; $i++) {
  my $line = $productions[&rand_idx(scalar(@productions))];

  $line =~ s/\\(0)/$good_adjectives[&rand_idx(scalar(@good_adjectives))]/g;
  $line =~ s/\\(1)/$good_nouns[&rand_idx(scalar(@good_nouns))]/g;

  $line =~ s/\\(2)/$bad_adjectives[&rand_idx(scalar(@bad_adjectives))]/g;
  $line =~ s/\\(3)/$bad_nouns[&rand_idx(scalar(@bad_nouns))]/g;

  $line =~ s/\\(4)/$tactics_agree[&rand_idx(scalar(@tactics_agree))]/g;
  $line =~ s/\\(5)/$tactics_object[&rand_idx(scalar(@tactics_object))]/g;

  $output .= $line . ' ';
}

print_wrapped($output, 72);

print "\n\n";

# END MAIN
##################################################

sub rand_idx {
  return int(rand(shift(@_)));
}

sub print_wrapped {
  my ($input, $wrap_width) = @_;
  my @words = split(/\s+/, $input);

  my $col = 0;
  while (scalar(@words)) {
    my $current_word = shift(@words);
    my $current_len = length($current_word);
    if ($col + $current_len > $wrap_width) {
      print "\n";
      $col = 0;
    }
    print $current_word . ' ';
    if ($current_word =~ /[\.\?]$/) { print ' '; }
    $col += $current_len + 1;
  }
}
