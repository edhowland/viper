rem vish_pkg.vsh the package for vish script runner vish
import option_processing
import init
load vish_lang
when_load vish { process_e init }

cd :proj
